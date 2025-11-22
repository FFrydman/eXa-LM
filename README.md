# eXa-LM  
*A Controlled Natural Language Bridge between Large Language Models and First-Order Logic Solvers*  

[https://10.5281/zenodo.17573374](https://doi.org/10.5281/zenodo.17573374)

**Version:** 1.0  
**License:** MIT  
© 2025 Francis Frydman  

---

##  What is eXa?

**eXa** is a controlled natural language interface
that translates controlled French text into executable First-Order Logic programs.
It connects natural-language reasoning with symbolic inference
and supports evaluation on logic benchmarks such as FOLIO, ProofWriter,
and ProntoQA.

**eXa** integrates:
-  **Symbolic parser:** `eXaSem` module (semantic analysis)  
-  **Prolog meta-interpreter:** `eXaLog` module (logical reasoning)
-  **Second order interpreter:** `eXaMeta` module (metalogical reasoning)
-  **Relational learner:** `eXaGol` module (optional hypothesis generation)

---

##  License Information

- **eXa-LM** is distributed under the **MIT License**.  
  You may use, modify, and redistribute it under these terms, provided the copyright
  notice and permission statement are retained.  

---

##  Requirements

- **Operating System:** Windows 10 or Windows 11 (64-bit)  
- **Database Engine:**  
  - Microsoft **Access 2016** or later  
  - *If Access is not installed*, please install:  
    [**Microsoft Access Database Engine 2016 (ACE, x64)**](https://www.microsoft.com/en-us/download/details.aspx?id=54920)
- **Prolog Engine:** 
	- **SWI-Prolog 9.2** or later
	- *If not installed*, please install, with *include in PATH* checked:
	[**SWI-Prolog for Microsoft Windows (64 bit)**] (https://www.swi-prolog.org/download/stable)
---

##  Installation

1. Download the latest version:  
   [https://github.com/FFrydman/eXa-LM/archive/refs/heads/main.zip](https://github.com/FFrydman/eXa-LM/archive/refs/heads/main.zip)
2. Unzip the archive into any folder of your choice.  
   *(No specific installation path required.)*

---

##  Usage

1. **Launch the program**  
   Run `eXa.exe`.

2. **Input window**  
   Enter **facts, rules, and questions (in French)**.

3. **Benchmark selector**  
   - Choose between **ProntoQA**, **ProofWriter**, or **FOLIO** benchmarks.  
   - *ProntoQA* and *ProofWriter* are split into several numbered files due to their size.  
   - *FOLIO* is provided in two versions:  
     - `FOLIO_dev (FULL)` — full development set  
     - `FOLIO_dev (ARTICLE)` — 182 selected examples used in the paper  
   - `QA_TESTS1` — various examples  
   - `Syllogisms` — examples of syllogistic reasoning  
   - `QA with learning (eXaGol)` — relational learning examples using the eXaGol module  

4. **Execution buttons**
   - **eXa** — full pipeline *(semantic parsing + Prolog reasoning)*  
   - **eXaSem (semantic analysis)** — runs symbolic parsing only  

5. **Output window**  
   Displays the reasoning results.

6. **Trace window**  
   Shows execution times for each step of the pipeline.

7. **Checkbox: “Generate hypotheses (with eXaGol)”**  
   - Enables **relational learning**, allowing eXaGol to infer new rules from known facts.  
   - ⚠️ **Do not enable** this option for the ProntoQA, ProofWriter, or FOLIO benchmarks.  
     It is intended only for the test *“QA with learning (eXaGol)”*.

---

##  Contact

Repository and contact: [https://github.com/FFrydman/eXa-LM](https://github.com/FFrydman/eXa-LM)

---

###  Citation

If you use **eXa-LM** in academic work, please cite:

> Frydman, F. (2025). *eXa-LM: A Controlled Natural Language Bridge between Large Language Models and First-Order Logic Solvers*.

---
