use std::path::{Path, PathBuf};

use anyhow::{Context, Result};

const GL_ASSETS: &[(&str, &str)] = &[
    ("bitify.circom", include_str!("../assets/circom/gl/bitify.circom")),
    ("cg_fft4.circom", include_str!("../assets/circom/gl/cg_fft4.circom")),
    ("cinv.circom", include_str!("../assets/circom/gl/cinv.circom")),
    ("cmul.circom", include_str!("../assets/circom/gl/cmul.circom")),
    ("elliptic_curve.circom", include_str!("../assets/circom/gl/elliptic_curve.circom")),
    ("evalpol.circom", include_str!("../assets/circom/gl/evalpol.circom")),
    ("fft.circom", include_str!("../assets/circom/gl/fft.circom")),
    ("fp.circom", include_str!("../assets/circom/gl/fp.circom")),
    ("fp5.circom", include_str!("../assets/circom/gl/fp5.circom")),
    ("iszero.circom", include_str!("../assets/circom/gl/iszero.circom")),
    ("linearhash.circom", include_str!("../assets/circom/gl/linearhash.circom")),
    ("linearhash_gpu.circom", include_str!("../assets/circom/gl/linearhash_gpu.circom")),
    ("merkle.circom", include_str!("../assets/circom/gl/merkle.circom")),
    ("merklehash.circom", include_str!("../assets/circom/gl/merklehash.circom")),
    ("merklehash_gpu.circom", include_str!("../assets/circom/gl/merklehash_gpu.circom")),
    ("mux1.circom", include_str!("../assets/circom/gl/mux1.circom")),
    ("mux2.circom", include_str!("../assets/circom/gl/mux2.circom")),
    ("poseidon.circom", include_str!("../assets/circom/gl/poseidon.circom")),
    ("poseidon2.circom", include_str!("../assets/circom/gl/poseidon2.circom")),
    ("poseidon2_1.circom", include_str!("../assets/circom/gl/poseidon2_1.circom")),
    ("poseidon2_constants.circom", include_str!("../assets/circom/gl/poseidon2_constants.circom")),
    ("poseidon_constants.circom", include_str!("../assets/circom/gl/poseidon_constants.circom")),
    ("pow.circom", include_str!("../assets/circom/gl/pow.circom")),
    ("selectval.circom", include_str!("../assets/circom/gl/selectval.circom")),
    ("treeselector.circom", include_str!("../assets/circom/gl/treeselector.circom")),
    ("treeselector4.circom", include_str!("../assets/circom/gl/treeselector4.circom")),
    ("utils.circom", include_str!("../assets/circom/gl/utils.circom")),
];

const VADCOP_ASSETS: &[(&str, &str)] = &[
    ("acc_points.circom", include_str!("../assets/circom/vadcop/acc_points.circom")),
    ("agg_values.circom", include_str!("../assets/circom/vadcop/agg_values.circom")),
    ("select_vk.circom", include_str!("../assets/circom/vadcop/select_vk.circom")),
];

#[derive(Debug, Clone)]
#[allow(dead_code)]
pub struct CircomIncludeDirs {
    pub gl: PathBuf,
    pub vadcop: PathBuf,
}

#[allow(dead_code)]
pub fn write_recursive_include_assets(base_dir: &Path) -> Result<CircomIncludeDirs> {
    let gl_dir = base_dir.join("gl");
    let vadcop_dir = base_dir.join("vadcop");
    write_assets(&gl_dir, GL_ASSETS)?;
    write_assets(&vadcop_dir, VADCOP_ASSETS)?;
    Ok(CircomIncludeDirs { gl: gl_dir, vadcop: vadcop_dir })
}

fn write_assets(dir: &Path, assets: &[(&str, &str)]) -> Result<()> {
    std::fs::create_dir_all(dir).with_context(|| format!("failed to create {}", dir.display()))?;
    for (name, contents) in assets {
        let path = dir.join(name);
        std::fs::write(&path, contents)
            .with_context(|| format!("failed to write Circom asset {}", path.display()))?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn writes_recursive_circom_assets() -> Result<()> {
        let dir =
            std::env::temp_dir().join(format!("pk_setup_circom_assets_{}", std::process::id()));
        if dir.exists() {
            std::fs::remove_dir_all(&dir)?;
        }
        let includes = write_recursive_include_assets(&dir)?;

        assert!(includes.gl.join("poseidon2.circom").exists());
        assert!(includes.gl.join("mux1.circom").exists());
        assert!(includes.vadcop.join("select_vk.circom").exists());

        std::fs::remove_dir_all(&dir)?;
        Ok(())
    }
}
