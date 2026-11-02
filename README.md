# ASEC-FEG QM/MM Geometry Optimization

A script-based implementation of the **average solvent electrostatic configuration–free energy gradient (ASEC-FEG)** protocol for QM/MM geometry optimization.

The workflow combines molecular dynamics sampling, an ensemble-averaged representation of the environment, QM/MM geometry optimization, and RESP atomic-charge updates. It connects **GROMACS**, **OpenMolcas/Tinker**, **ORCA**, and **Multiwfn** through Bash, Python, Fortran, and Tcl utilities.

> **Before running:** Modify and rebuild Tinker as described below. The scripts also require system-specific molecular inputs, selections, paths, and calculation settings.

## Method overview

ASEC-FEG incorporates thermal fluctuations of the environment into chromophore geometry optimization.

The workflow alternates between:

1. **MD sampling:** Sample a selected region of the MM environment while keeping the chromophore geometry and the unsampled environment fixed.
2. **ASEC generation:** Superpose sampled configurations to construct clouds of interaction sites representing the sampled environment atoms.
3. **QM/MM optimization:** Optimize the chromophore geometry in the resulting ASEC environment.
4. **RESP charge update:** Refit the chromophore atomic charges and transfer the updated geometry and charges to the next MD stage.
5. **Iteration:** Repeat the cycle and assess convergence from the QM/MM energy.

The supplied implementation uses **100 sampled configurations**. This is a configurable implementation choice rather than a defining requirement of ASEC-FEG.

### ASEC interaction sites

For \(N\) sampled configurations, each atom \(i\) in the sampled region is represented by \(N\) interaction sites at its sampled positions. Their atomic charges and van der Waals well-depth parameters are scaled according to

\[
q_i^{(k)}=\frac{q_i}{N},
\qquad
\epsilon_i^{(k)}=\frac{\epsilon_i}{N^2},
\qquad
k=1,\ldots,N.
\]

Van der Waals size parameters remain unchanged.

The \(1/N^2\) factor applies to the **per-site well-depth parameter**. With geometric mixing of well-depth parameters, the interaction between an environmental site and an unscaled chromophore atom is consequently scaled by \(1/N\).

In the supplied implementation, one sampled position is retained in a representative configuration, and the remaining positions are added as pseudoatoms. Together, these sites form the ASEC representation. Atoms outside the sampled region retain their conventional MM representation.

## Required software

| Software | Purpose |
|---|---|
| GROMACS | MD sampling and trajectory processing |
| OpenMolcas | Electronic-structure calculations, electrostatic embedding, gradients, and geometry optimization |
| Tinker | MM calculations coupled to OpenMolcas |
| ORCA | Electronic-structure calculations for atomic-charge refitting |
| Multiwfn | RESP atomic-charge fitting |
| VMD | Structure processing and Tcl-based selections |
| Python | Coordinate conversion, input preparation, and topology updates |
| Fortran compiler | Compilation of the supplied Fortran utilities |
| Bash and standard Unix utilities | Workflow orchestration and text processing |

Use compatible OpenMolcas and Tinker installations with the required QM/MM interface enabled.

Software versions, executable paths, processor counts, memory settings, and scratch directories must be configured for the target workstation or computing cluster.

## Mandatory Tinker modification

**Before launching the workflow, modify the Tinker source file `ksolv.f` and rebuild the affected Tinker components.**

In the reference source version, replace **lines 446–450** with:

```fortran
              if (atmnum .eq. 1) then
                rsolv(i) = 1.25d0
                if (n12(i) .gt. 0) then
                  k = i12(1,i)
                  if (atomic(k) .eq. 7)  rsolv(i) = 1.15d0
                  if (atomic(k) .eq. 8)  rsolv(i) = 1.05d0
                end if
```

This block belongs within the existing routine: preserve the surrounding conditional structure and its matching closing statements.

**Line numbers can differ between Tinker versions.** Locate and inspect the corresponding hydrogen-radius assignment block rather than replacing lines solely by their numerical position.

Recommended procedure:

1. Back up the original `ksolv.f`.
2. Apply the replacement above.
3. Check the surrounding Fortran control structure.
4. Recompile Tinker following the build procedure for the installed version.
5. Rebuild or relink any affected components used by the OpenMolcas/Tinker interface.
6. Confirm that the workflow uses the rebuilt installation rather than another Tinker installation.

Changing `ksolv.f` without rebuilding the affected components does not update the executable code.

## Repository contents

### Workflow and preparation

| File | Purpose |
|---|---|
| `asec_cavity.sh` | Main driver for the supplied iterative workflow |
| `gen_step0.sh` | Initial preparation entry script |
| `asecgen_step0.sh` | ASEC preparation for the initial iteration |
| `asecgen_step1.sh` | ASEC preparation for subsequent iterations |
| `asec_mmmd.sh` | MD-stage workflow helper |
| `mdrun_cavity.sh` | MD execution and trajectory-processing stage |
| `asec2qmmm.sh` | Preparation of the ASEC model for QM/MM calculations |
| `energyminimization.sh` | Energy-minimization helper |
| `gen_simbox.sh` | Simulation-box preparation |
| `boxdimensions.py` | Box-dimension utility |
| `cavity_from_size.tcl` | Spatial selection of an environment region |
| `factors_qm.sh` | QM/MM parameter-processing helper |

### Coordinate and topology processing

| File | Purpose |
|---|---|
| `arm_pdb_format.py` | PDB-format preparation |
| `arm_tinker_pdb2xyz.py` | Conversion to Tinker XYZ format |
| `correct_top.py` | GROMACS topology processing |
| `update_charges.py` | Transfer of updated atomic charges to the MD topology |
| `qmcoords.py` | QM-coordinate extraction |
| `qmcoords_dft.py` | QM-coordinate extraction for the DFT workflow |

### Charge refitting

| File | Purpose |
|---|---|
| `resp_dft.sh` | Charge-refitting workflow |
| `gen_orca.sh` | ORCA input preparation |
| `field_dft.py` | Electrostatic-environment preparation |
| `field_dft_resp.py` | Electrostatic-environment preparation for charge refitting |

### Fortran utilities and templates

| File | Purpose |
|---|---|
| `ASEC.f` | ASEC-model construction |
| `MD_ASEC.f` | Processing of sampled configurations |
| `New_parameters.f` | Generation of scaled interaction parameters |
| `Templates_gro_tk.f` | GROMACS/Tinker template processing |
| `protein_dft.input` | OpenMolcas input template |
| `protein_dft.key` | Tinker/QM/MM key-file template |
| `final_protein.key` | Additional Tinker key-file template |
| `melacu63.prm` | Tinker force-field parameter file |

Some distributed files may have an additional `.txt` suffix. Restore the filenames expected by the scripts before use, for example:

```text
ASEC.f.txt                  → ASEC.f
MD_ASEC.f.txt               → MD_ASEC.f
New_parameters.f.txt        → New_parameters.f
Templates_gro_tk.f.txt      → Templates_gro_tk.f
cavity_from_size.tcl.txt    → cavity_from_size.tcl
protein_dft.input.txt       → protein_dft.input
protein_dft.key.txt         → protein_dft.key
final_protein.key.txt       → final_protein.key
melacu63.prm.txt            → melacu63.prm
```

## Molecular input preparation

The workflow starts from a **prepared molecular model**, not an arbitrary PDB file.

Provide and validate:

- Molecular coordinates with suitable atom and residue names.
- The chromophore/QM-region definition.
- A compatible GROMACS topology and all included topology files.
- Tinker coordinates, key files, and parameters.
- Initial chromophore atomic charges.
- The mobile environment selection.
- Covalent QM/MM boundary definitions, where applicable.
- MD parameter files and index groups.
- Quantum chemical method, basis set, total charge, and spin multiplicity.

**Atom ordering must remain consistent** throughout coordinate conversion, QM-coordinate extraction, RESP fitting, and topology updates.

The supplied templates contain application-specific selections and settings. For another molecular system, review atom names, residue names, atom types, connectivity, and boundary definitions before execution.

## Configuration

### Paths and execution settings

Inspect the scripts and configure:

- External-program executable names and paths.
- Input and working directories.
- Processor and memory settings.
- Scratch directories.
- Environment initialization.
- Scheduler-specific commands, if applicable.

Compile the Fortran utilities using the executable names expected by their calling scripts.

### MD sampling

Define the mobile environment region and verify that the MD constraints or freeze settings keep the chromophore and unsampled environment fixed.

Check the actual GROMACS parameter files and index groups. A spatial selection alone does not establish which atoms are fixed during MD.

### Number of configurations

The supplied workflow extracts 100 configurations.

If this number is changed, review all dependent settings, including frame extraction, loop bounds, array dimensions, site counts, and parameter scaling.

**Regular frame spacing does not guarantee statistical independence.** Equilibration and the sampling interval should be assessed for each system.

### QM/MM optimization

The supplied OpenMolcas template uses `&SCF` with B3LYP and the 6-31G* basis set.

The ASEC-FEG protocol is not restricted to this electronic-structure method. Adapting the calculation requires checking compatibility with the embedding, gradient, geometry-optimization, and charge-refitting stages.

The optimization uses the electronic-structure module together with:

- `&ESPF` for electrostatic embedding and coupling to Tinker.
- `&ALASKA` for gradient evaluation.
- `&SLAPAF` for geometry updates.

ASEC pseudoatom coordinates remain fixed during QM/MM optimization.

**Inspect the Tinker `ACTIVE` selections and microiteration settings.** The supplied key file activates selected conventional MM atoms at the covalent QM/MM boundary and enables QM/MM microiterations. Therefore, an assumption that all conventional MM atoms are fixed does not exactly describe that input.

### RESP charge fitting

Configure the ORCA and Multiwfn stages for the intended chromophore and charge-fitting procedure.

Check:

- Total charge and spin multiplicity.
- Electronic-structure settings.
- The surrounding point-charge representation.
- RESP restraints and charge constraints.
- Coordinate and atom ordering.
- Mapping of fitted charges to the MD topology.

After each update, verify the assigned charges and the total chromophore charge.

## Running

### Pre-run checklist

Before launching the full workflow:

- Apply the required `ksolv.f` modification and rebuild Tinker.
- Configure external-program paths.
- Compile the Fortran utilities.
- Restore operational filenames where `.txt` was appended.
- Supply all molecular inputs and referenced helper files.
- Validate atom selections and mappings.
- Check MD constraints and QM/MM active-atom settings.
- Test the individual external calculations.
- Preserve an untouched copy of the starting model.

Run calculations in a dedicated working directory.

### Launch the driver

After configuration and input preparation:

```bash
bash asec_cavity.sh
```

The supplied driver runs `Step_0` followed by steps 1–5.

Inspect the driver before changing the iteration range or restarting an existing calculation. Existing intermediate files may otherwise be reused or overwritten unintentionally.

### Convergence assessment

**The supplied driver runs a predefined number of iterations; it does not implement automatic energy-based termination.**

Assess convergence separately by monitoring the change in the relevant QM/MM energy between successive completed iterations.

Use a consistent energy definition, retain the energy history, and extend the iteration sequence if necessary. Successful completion of the driver does not by itself demonstrate convergence.

## Additional required files

The supplied scripts reference the following additional files:

| File | Role |
|---|---|
| `ndx_cavity.sh` | MD index-group preparation |
| `mdrun.mdp` | MD run parameters |
| `respheaderorca` | ORCA/charge-fitting input preparation |
| `update_dft.sh` | Update stage between iterations |

Ensure these files are available in the locations expected by the scripts. If they are generated by another preparation stage, document that stage and check that it has completed before launching the driver.

## Validation

Before interpreting the final model, verify:

- The intended environment atoms moved during MD.
- The chromophore remained fixed during MD.
- The requested trajectory configurations were processed.
- ASEC site counts and positions match the sampled region.
- Charges and van der Waals well-depth parameters were scaled correctly.
- Van der Waals size parameters were preserved.
- QM/MM boundary connectivity and active-atom selections are correct.
- Every geometry optimization completed successfully.
- RESP charges satisfy the required total charge.
- Updated geometry and charges were transferred to the next iteration.
- The QM/MM energy satisfies the chosen convergence criterion.

For reproducibility, retain the software versions, modified Tinker source, molecular inputs, selection definitions, sampling settings, calculation logs, fitted charges, and energy history.

## Troubleshooting

| Problem | Checks |
|---|---|
| External program not found | Executable paths and environment initialization |
| Tinker modification appears ineffective | Rebuild status and the installation actually used by OpenMolcas |
| Coordinate conversion fails | Atom names, residue names, connectivity, and supported components |
| Incorrect atoms move during MD | Index groups and MD constraint or freeze settings |
| Unexpected ASEC site count | Mobile-region size, frame count, and trajectory processing |
| Implausible optimized geometry | Atom types, charge assignments, parameter scaling, and boundary treatment |
| Charge update fails | ORCA completion, Multiwfn settings, output parsing, and atom ordering |
| Iterations finish without convergence | Sampling quality, optimization completion, and consistency of transferred inputs |

## Required citations

**Publications using this workflow should cite both articles:**

1. Orozco-Gonzalez, Y.; Manathunga, M.; Marin, M. D. C.; Agathangelou, D.; Jung, K. H.; Melaccio, F.; et al. **An Average Solvent Electrostatic Configuration Protocol for QM/MM Free Energy Optimization: Implementation and Application to Rhodopsin Systems.** *Journal of Chemical Theory and Computation* **2017**, *13* (12), 6391–6404.

2. Nikolaev, D. M.; Manathunga, M.; Orozco-Gonzalez, Y.; Shtyrov, A. A.; Guerrero Martinez, Y. O.; Gozem, S.; et al. **Free Energy Computation for an Isomerizing Chromophore in a Molecular Cavity via the Average Solvent Electrostatic Configuration Model: Applications in Rhodopsin and Rhodopsin-Mimicking Systems.** *Journal of Chemical Theory and Computation* **2021**, *17* (9), 5885–5895.

Also cite the external software packages used in the calculation according to their respective citation instructions.

## Licensing

Consult the repository license before using or redistributing the code. Third-party software, parameter files, and derived utilities may have separate licensing conditions. If no repository license is provided, contact the maintainers for permission and clarification.
