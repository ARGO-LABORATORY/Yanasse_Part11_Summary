# Yanasse Part 11: Summary of the Initial Campaign

100 transfer attempts, 10 papers, 35 new Lean-verified theorems &mdash; the structural map of Mathlib transferability.

> **Method.** GPU-accelerated NP-hard relational analogy (Deep Vision, running on a MacBook Air via Apple MPS) identifies structurally similar proof states across 217,133 Mathlib-extracted entries; an AI reasoning agent semantically adapts the source tactic pattern to the target theorem. The matching engine is entirely domain-independent: the same code that matches chess positions by analogy matches Lean proof states, without knowing which domain it is processing.

## Repository contents

| File | Description |
|------|-------------|
| `yanasse_summary.tex` | Paper (LaTeX source) |
| `yanasse_summary.pdf` | Compiled paper (20 pages) |
| `data/naive_transfer_potential_matrix.csv` | 26&times;24 transfer potential matrix (naive z-score gap model) |
| `data/naive_transfer_potential_matrix.parquet` | Same, Parquet format |
| `data/weighted_transfer_potential_matrix.csv` | 26&times;24 transfer potential matrix (transferability-weighted model) |
| `data/weighted_transfer_potential_matrix.parquet` | Same, Parquet format |
| `data/all_pairs_ranked.csv` | All 598 area pairs ranked by both models |
| `data/all_pairs_ranked.parquet` | Same, Parquet format |
| `data/tactic_transfer_rates.csv` | Empirical transfer rates per tactic class (from the 100-attempt campaign) |

## Cumulative results

| # | Pair | Schemas | New thm | Rate |
|---|------|---------|---------|------|
| 1 | Probability &rarr; RepresentationTheory | 10 | 4 | 40% |
| 2 | Probability &rarr; SetTheory | 10 | 4 | 40% |
| 3 | Probability &rarr; Condensed | 10 | 2 | 20% |
| 4 | Probability &rarr; FieldTheory | 10 | 4 | 40% |
| 5 | Probability &rarr; Dynamics | 10 | 4 | 40% |
| 6 | Probability &rarr; ModelTheory | 10 | 5 | 50% |
| 7 | Probability &rarr; InformationTheory | 10 | 9 | 90% |
| 8 | NumberTheory &rarr; Condensed | 10 | 0 | 0% |
| 9 | NumberTheory &rarr; RepresentationTheory | 10 | 0 | 0% |
| 10 | NumberTheory &rarr; Dynamics | 10 | 3 | 30% |
| | **Total** | **100** | **35** | **35%** |

By source: Probability 32/70 (46%), Number Theory 3/30 (10%).

## Key findings

1. **Two-factor model.** Transfer success &asymp; *f*(source tactic profile) &times; *g*(target type-class landscape). Structural combinators transfer broadly (~60%); algebraic decision procedures transfer narrowly (~10%).

2. **Element/morphism paradigm boundary.** Algebraic decision procedures (`ring`, `linarith`, `norm_num`) cannot cross from element-level to morphism-level proof domains, except where element-level sub-layers exist (e.g., Dynamics' translation numbers embed &Ropf;-arithmetic within topological proofs).

3. **Tactic taxonomy.** Structural combinators (`ext1`, `by_cases`, `any_goals`) succeed in 5+/7 targets. Algebraic procedures succeed in 1/3 targets (only with type-class compatibility). Meta-tactics (`enter`) transfer independently of QAP scores.

4. **Complementarity.** Different source areas produce non-overlapping successful transfers to the same target. Probability accesses the measure-theoretic layer of Dynamics; Number Theory accesses the arithmetic layer. Combined: 7 new theorems vs. 4 or 3 alone.

5. **Transferability-weighted model.** Reweighting pair potential by empirical transfer rates per tactic class dramatically reshuffles the rankings &mdash; Number Theory pairs drop, structural-combinator-heavy sources rise. The weighted model should be used for future pair selection.

## The structural map

The paper includes two 23&times;23 transfer potential matrices covering all Mathlib mathematical areas:

- **Naive model** (Table 6): pair potential from raw z-score gaps, used to select the initial campaign
- **Weighted model** (Table 7): pair potential weighted by empirical transfer rates, for selecting future campaigns

Both matrices are available as CSV and Parquet in the `data/` directory. Usage:

```python
import pandas as pd
naive = pd.read_parquet('data/naive_transfer_potential_matrix.parquet')
weighted = pd.read_parquet('data/weighted_transfer_potential_matrix.parquet')
pairs = pd.read_parquet('data/all_pairs_ranked.parquet')
rates = pd.read_csv('data/tactic_transfer_rates.csv')

# Top 10 pairs by weighted model (excluding completed pairs)
print(pairs.head(10))
```

## Individual papers

| Part | Pair | Repo |
|------|------|------|
| 1 | Probability &rarr; RepresentationTheory | [Yanasse_Part1](https://github.com/ARGO-LABORATORY/Yanasse_Part1_Probability_to_RepresentationTheory) |
| 2 | Probability &rarr; SetTheory | [Yanasse_Part2](https://github.com/ARGO-LABORATORY/Yanasse_Part2_Probability_to_SetTheory) |
| 3 | Probability &rarr; Condensed | [Yanasse_Part3](https://github.com/ARGO-LABORATORY/Yanasse_Part3_Probability_to_Condensed) |
| 4 | Probability &rarr; FieldTheory | [Yanasse_Part4](https://github.com/ARGO-LABORATORY/Yanasse_Part4_Probability_to_FieldTheory) |
| 5 | Probability &rarr; Dynamics | [Yanasse_Part5](https://github.com/ARGO-LABORATORY/Yanasse_Part5_Probability_to_Dynamics) |
| 6 | Probability &rarr; ModelTheory | [Yanasse_Part6](https://github.com/ARGO-LABORATORY/Yanasse_Part6_Probability_to_ModelTheory) |
| 7 | Probability &rarr; InformationTheory | [Yanasse_Part7](https://github.com/ARGO-LABORATORY/Yanasse_Part7_Probability_to_InformationTheory) |
| 8 | NumberTheory &rarr; Condensed | [Yanasse_Part8](https://github.com/ARGO-LABORATORY/Yanasse_Part8_NumberTheory_to_Condensed) |
| 9 | NumberTheory &rarr; RepresentationTheory | [Yanasse_Part9](https://github.com/ARGO-LABORATORY/Yanasse_Part9_NumberTheory_to_RepresentationTheory) |
| 10 | NumberTheory &rarr; Dynamics | [Yanasse_Part10](https://github.com/ARGO-LABORATORY/Yanasse_Part10_NumberTheory_to_Dynamics) |

## Deep Vision vs. Deep Neural Networks

Deep Vision is the technology behind ARGO LABORATORY's entry to [Chollet's ARC-AGI](https://arcprize.org/) challenge. It represents a fundamentally different paradigm from deep learning:

| | **Deep Vision** | **Deep Neural Networks** |
|---|---|---|
| **Explainability** | Full step-by-step trace: which relations matched, which entities corresponded, why a particular analogy was chosen. Can explain to any judge why a decision was made --- and what to change to get a different outcome. | Black box. Gradient-based attribution methods (SHAP, LIME) are post-hoc approximations, not the actual reasoning path. |
| **Efficiency** | < $0.01 per ARC-AGI task suite (100s of tasks). Runs in a browser, in JavaScript, on a CPU, on a phone, in airplane mode. The NP-hard matching runs on commodity hardware --- a MacBook Air's GPU discovered these 35 new proofs. | $2+ per task suite (frontier models). Requires data-center GPUs, high-bandwidth interconnects, megawatts of power. |
| **Representation** | Emergent and distributed. The system *crafts* its representation as it studies each problem --- entities, relations, and correspondences emerge from the structure of the specific situation. | Fixed. Representations are learned once during training and frozen at inference. The network cannot restructure its representation for a novel problem. |
| **Paradigm** | Relational analogy as cognition. Intelligence is perceiving shared relational structure across superficially different situations (Hofstadter, 1995). Domain-independent: the same matching engine handles chess, theorem proving, and ARC-AGI tasks. | Statistical pattern completion. Intelligence is next-token prediction over massive corpora. Domain generality comes from scale, not from architectural principles. |
| **Accessibility** | Fluid general intelligence in your pocket, regardless of who you are, where you live, or what you can afford. Runs offline, on-device, no API keys, no subscriptions, no data leaving the device. | Controlled by a handful of data-center owners. Requires internet, API access, and per-token payment. Concentrates capability in the hands of those who can afford the infrastructure. |

## Citation

```bibtex
@article{linhares2026yanasse11,
  title   = {Yanasse: Finding New Proofs from Deep Vision's Analogies --- Part~11:
             Summary of the Initial Campaign},
  author  = {Linhares, Alexandre},
  year    = {2026},
  month   = {April},
  publication = {Argolab.org Report for Dissemination}
}
```

## Authors

- **Alexandre Linhares** (alexandre@linhares.ltd)

## License

MIT. See [LICENSE](LICENSE).
