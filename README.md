# Zero-Trust: Hardened Supply Chain Pipeline

This project demonstrates a production-grade **DevSecOps CI/CD pipeline** designed with a "Verify, then Trust" philosophy. It secures the entire software development lifecycle (SDLC)—from the developer's local shell to the final signed container artifact.

The application is a Python-based API intentionally designed with vulnerabilities to demonstrate the efficacy of the security gates.

## Architecture & Security Gates

The pipeline implements five layers of defense-in-depth:

1. **Local Pre-Commit (Gitleaks):** Prevents secrets (API keys, tokens) from ever entering the Git history.
2. **Static Analysis (Semgrep SAST):** Scans source code for dangerous patterns (e.g., insecure deserialization via `pickle`).
3. **SCA & SBOM (Syft/Grype):** Generates a Software Bill of Materials (SBOM) and scans deep dependencies for known CVEs.
4. **Immutable Infrastructure:** Uses specific SHA256 container digests instead of mutable tags (like `:latest`).
5. **Artifact Integrity (Cosign):** Signs the final container image using OIDC identity to ensure only verified code runs in production.

---

## 🛠️ The Tech Stack

| Layer | Tool | Purpose |
| --- | --- | --- |
| **OS / Shell** | Parrot OS / Fish | Security-focused development environment |
| **Pipeline** | GitHub Actions | Automation and Orchestration |
| **Secrets** | Gitleaks | Secret detection and prevention |
| **SAST** | Semgrep | Code logic & vulnerability scanning |
| **SCA** | Grype | Dependency vulnerability management |
| **Integrity** | Sigstore/Cosign | Digital signing of container images |

---

## 🚀 Getting Started

### Local Development

To set up the local security hooks:

```fish
# Install Gitleaks and configure pre-commit
git config core.hooksPath .githooks
echo "gitleaks protect --staged" > .githooks/pre-commit
chmod u+x .githooks/pre-commit

```

### Build & Scan

To manually trigger the security audit:

```fish
# Generate SBOM
syft python-app:v1 -o json > sbom.json

# Scan for High/Critical vulnerabilities
grype sbom.json --fail-on high

```

---

## 📊 Pipeline Failure Scenarios

This repository is configured to **fail** under the following conditions (simulating real-world security enforcement):

* **Logic Error:** If `pickle.loads()` is found in the code, **Semgrep** will block the build.
* **Vulnerable Library:** If `requirements.txt` contains a library with a High-severity CVE, **Grype** will kill the job.
* **Secret Leak:** If a string resembling a private key is committed, **Gitleaks** will abort the commit.

---
