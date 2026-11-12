# Security Policy

Venus is Cysic's acceleration and specialization of the ZisK zkVM. Like ZisK, its job is to make sure that a valid proof can only be produced for a correct execution. We take reports of anything that undermines that guarantee seriously, and we appreciate the work of researchers who find and disclose such issues responsibly.

Venus is under active development and has not been audited. It is built on ZisK v1.4.0-alpha, which is itself undergoing security and correctness audits.

## Supported Versions

Security fixes go into `main` and are shipped in the next release. Older releases are not patched.

| Version          | Supported |
| ---------------- | --------- |
| Latest release   | Yes       |
| Earlier releases | No        |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues, pull requests or discussions.**

Report them privately through GitHub instead:

1. Go to the [Security tab](https://github.com/cysic-zk/venus/security) of this repository.
2. Click **Report a vulnerability**, or use [this link](https://github.com/cysic-zk/venus/security/advisories/new) directly.

Only the reporter and the Venus maintainers can see the report.

Please include as much of the following as you can:

- The affected component (for example the GPU prover, a state machine or PIL file, a precompile, the verifier or the Solidity contracts).
- The version or commit SHA you tested, and the file and line where the problem is.
- A description of the issue and its impact.
- A proof of concept: for a soundness issue, a statement the verifier accepts although it is false, or a witness that satisfies the constraints without corresponding to a correct execution; for other issues, steps to reproduce.
- A suggested fix, if you have one.

## Scope

Reports about any code in this repository are welcome. Most of it comes from ZisK, pil2-proofman and pil2-compiler: when an issue is also present in those projects, we coordinate the fix with their maintainers before disclosing it. You may also report such issues to them directly, following the [ZisK security policy](https://github.com/0xPolygonHermez/zisk/security/policy).

## What to Expect

- We will acknowledge your report as soon as possible.
- We will send an initial assessment, including whether we consider it a vulnerability and how severe it is.
- We will keep you informed while we work on a fix, and agree with you on the disclosure timing.
- With your permission, we will credit you in the release notes of the fix.
