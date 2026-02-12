# Venus HLS Components - Aggregator Makefile
#
# Prerequisites: module load amd/2025.2
#
# Iterates over all HLS component directories in dependency order.
# Each component has its own Makefile that delegates to test/.
#
# Targets:
#   csim     - C-simulation for all components
#   csynth   - C-synthesis for all components
#   cosim    - Co-simulation for all components
#   package  - Package all components as XO
#   clean    - Clean all component build artifacts

# Components in dependency order:
#   goldilocks - no deps (base field arithmetic)
#   ntt        - depends on goldilocks
#   poseidon2  - depends on goldilocks
#   merkle     - depends on goldilocks, poseidon2
#   expressions - depends on goldilocks
#   fri        - depends on goldilocks (cubic extension)
#   transcript - depends on goldilocks, poseidon2
COMPONENTS := goldilocks ntt poseidon2 merkle expressions fri transcript proof
PART ?= xcvu47p-fsvh2892-3-e

.PHONY: csim csynth cosim package clean help \
        $(addprefix csim-,$(COMPONENTS)) \
        $(addprefix csynth-,$(COMPONENTS)) \
        $(addprefix cosim-,$(COMPONENTS)) \
        $(addprefix package-,$(COMPONENTS)) \
        $(addprefix clean-,$(COMPONENTS))

# ---- Aggregate targets (all components) ----

csim:
	@for comp in $(COMPONENTS); do \
		echo ""; \
		echo "======================================"; \
		echo "  csim: $$comp"; \
		echo "======================================"; \
		$(MAKE) -C $$comp PART="$(PART)" csim || exit 1; \
	done
	@echo ""
	@echo "=== All C-simulations passed ==="

csynth:
	@for comp in $(COMPONENTS); do \
		echo ""; \
		echo "======================================"; \
		echo "  csynth: $$comp"; \
		echo "======================================"; \
		$(MAKE) -C $$comp PART="$(PART)" csynth || exit 1; \
	done
	@echo ""
	@echo "=== All C-syntheses completed ==="

cosim:
	@for comp in $(COMPONENTS); do \
		echo ""; \
		echo "======================================"; \
		echo "  cosim: $$comp"; \
		echo "======================================"; \
		$(MAKE) -C $$comp PART="$(PART)" cosim || exit 1; \
	done
	@echo ""
	@echo "=== All co-simulations passed ==="

package:
	@for comp in $(COMPONENTS); do \
		echo ""; \
		echo "======================================"; \
		echo "  package: $$comp"; \
		echo "======================================"; \
		$(MAKE) -C $$comp PART="$(PART)" package || exit 1; \
	done
	@echo ""
	@echo "=== All components packaged ==="

clean:
	@for comp in $(COMPONENTS); do \
		$(MAKE) -C $$comp PART="$(PART)" clean; \
	done

# ---- Per-component targets (e.g., make csim-ntt) ----

$(addprefix csim-,$(COMPONENTS)):
	$(MAKE) -C $(subst csim-,,$@) PART="$(PART)" csim

$(addprefix csynth-,$(COMPONENTS)):
	$(MAKE) -C $(subst csynth-,,$@) PART="$(PART)" csynth

$(addprefix cosim-,$(COMPONENTS)):
	$(MAKE) -C $(subst cosim-,,$@) PART="$(PART)" cosim

$(addprefix package-,$(COMPONENTS)):
	$(MAKE) -C $(subst package-,,$@) PART="$(PART)" package

$(addprefix clean-,$(COMPONENTS)):
	$(MAKE) -C $(subst clean-,,$@) PART="$(PART)" clean

# ---- Help ----

help:
	@echo "Venus HLS Aggregator"
	@echo ""
	@echo "Aggregate targets (all components):"
	@echo "  csim       - C-simulation for all components"
	@echo "  csynth     - C-synthesis for all components"
	@echo "  cosim      - Co-simulation for all components"
	@echo "  package    - Package all components as XO"
	@echo "  clean      - Clean all build artifacts"
	@echo ""
	@echo "Per-component targets:"
	@echo "  csim-<comp>    - C-simulation for one component"
	@echo "  csynth-<comp>  - C-synthesis for one component"
	@echo "  cosim-<comp>   - Co-simulation for one component"
	@echo "  package-<comp> - Package one component"
	@echo "  clean-<comp>   - Clean one component"
	@echo ""
	@echo "Components: $(COMPONENTS)"
