//! Template engine wrapper around the Tera crate.
//!
//! Provides helpers for loading templates from the `templates/` directory
//! and rendering them with a `tera::Context`.

use anyhow::{Context as _, Result};
use std::path::{Path, PathBuf};
use tera::{Context, Tera};

/// Locate the `templates/` directory relative to the crate root.
///
/// At compile time we resolve via `CARGO_MANIFEST_DIR`; at run time
/// the caller may override by providing a custom base path.
fn default_template_dir() -> PathBuf {
    let manifest = env!("CARGO_MANIFEST_DIR");
    Path::new(manifest).join("templates")
}

/// A thin wrapper around [`tera::Tera`] pre-loaded with the crate's
/// template directory.
pub struct TemplateEngine {
    tera: Tera,
}

impl TemplateEngine {
    /// Create a new engine loading all `*.tera` files under the default
    /// `templates/` directory (recursively).
    pub fn new() -> Result<Self> {
        let dir = default_template_dir();
        Self::from_dir(&dir)
    }

    /// Create a new engine loading all `*.tera` files under `dir`.
    pub fn from_dir(dir: &Path) -> Result<Self> {
        let glob = format!("{}/**/*.tera", dir.display());
        let tera = Tera::new(&glob)
            .with_context(|| format!("failed to load Tera templates from {}", dir.display()))?;
        Ok(Self { tera })
    }

    /// Render a named template (path relative to the template root,
    /// e.g. `"vadcop/compressor.circom.tera"`) with the given context.
    pub fn render(&self, name: &str, ctx: &Context) -> Result<String> {
        self.tera
            .render(name, ctx)
            .with_context(|| format!("failed to render template '{name}'"))
    }

    /// Convenience: render an inline template string (not from file)
    /// with the given context.
    pub fn render_inline(template_str: &str, ctx: &Context) -> Result<String> {
        let mut tera = Tera::default();
        tera.add_raw_template("__inline__", template_str)
            .context("failed to parse inline template")?;
        tera.render("__inline__", ctx)
            .context("failed to render inline template")
    }

    /// Return a reference to the inner [`Tera`] instance, for advanced use
    /// (e.g. registering custom filters or functions).
    pub fn inner(&self) -> &Tera {
        &self.tera
    }

    /// Return a mutable reference to the inner [`Tera`] instance.
    pub fn inner_mut(&mut self) -> &mut Tera {
        &mut self.tera
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_engine_loads() {
        let engine = TemplateEngine::new().expect("should load templates");
        let names: Vec<&str> = engine.inner().get_template_names().collect();
        // We expect at least the vadcop templates
        assert!(
            !names.is_empty(),
            "template engine should find at least one template"
        );
    }

    #[test]
    fn test_render_inline() {
        let mut ctx = Context::new();
        ctx.insert("name", "world");
        let result = TemplateEngine::render_inline("hello {{ name }}", &ctx)
            .expect("inline render should work");
        assert_eq!(result, "hello world");
    }
}
