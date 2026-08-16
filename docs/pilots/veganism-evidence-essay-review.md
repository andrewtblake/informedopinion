# Veganism evidence essay: pilot review

## Purpose

This review tests whether the Veganism fact bank can support a readable evidence
essay, whether every fact question needs to appear, whether the two site
presentations need separate articles, and how gateway facts should affect quiz
ordering. It accompanies the unpublished draft in
`docs/pilots/veganism-evidence-essay.md`.

## Gateway-fact audit

For this pilot, a gateway fact is consequential, readily understood by a
non-specialist and useful for orienting the reader to one of the proposition's
main issues. It is not merely an easy item.

Ten of the current questions are particularly suitable:

| Fact ID | Gateway fact | Importance | Specialist knowledge | Answerability | Direction |
| ---: | --- | ---: | ---: | ---: | --- |
| 612 | A varied, balanced vegan diet can provide an adult's required nutrients | 3 | 1 | 4 | Supports |
| 613 | Vitamin B12 has limited vegan sources and may require supplementation | 3 | 1 | 4 | Counters |
| 617 | Long-term health evidence remains incomplete | 2 | 2 | 4 | Contextual |
| 622 | Vegans had higher total- and hip-fracture risks in EPIC-Oxford | 3 | 3 | 3 | Counters |
| 627 | Plant-rich diets can reduce emissions and bring health co-benefits | 3 | 2 | 3 | Supports |
| 633 | Livestock agrifood systems produced about 12% of human-caused emissions in 2015 | 3 | 2 | 3 | Supports |
| 636 | Approximately 1.036 billion animals were slaughtered in UK slaughterhouses in 2025/26 | 3 | 2 | 3 | Supports |
| 637 | Detected welfare-law breaches at slaughter affected about 0.0032% of those animals | 2 | 3 | 2 | Counters |
| 641 | UK population-adjusted veterinary-antibiotic sales fell 57% from 2014 to 2024 | 2 | 2 | 3 | Counters |
| 642 | Health feasibility varies with needs, access, health and circumstances | 3 | 1 | 5 | Contextual |

Fact 637 is a gateway issue but a relatively demanding presented question. It
should appear early enough to counter an incomplete welfare account, though not
necessarily among the first few questions.

### What the current algorithm does

`NextFactQuestion` does not currently recognise gateway status, importance,
specialist knowledge, answerability or editorial display order. For each quiz
position it:

1. selects a preferred evidential direction from a fixed progression adjusted
   to the participant's stance;
2. places questions in that direction first, a second direction next and all
   remaining questions last; and
3. randomises questions within those groups.

The ten gateway facts therefore receive no preference over specialised facts of
the same direction. For example, an agreeing participant's opening supporting
slot is as capable of selecting the detailed 3.1-billion-hectare model estimate
as the basic nutritional-feasibility question. A disagreeing participant can
encounter the exact detected-breach percentage before the simpler vitamin B12
constraint. A participant with a neutral stance can receive a technical
plant-drink or observational-method item before the general feasibility
qualification.

The existing valence progression and early introduction of counterevidence are
worth retaining. A later implementation should prefer gateway facts within each
required direction during the opening positions, rather than replace the
valence progression with a simple easy-to-hard sort.

## Fact-to-essay coverage

Coverage refers to the factual substance, not repetition of the quiz wording.
`Direct` means the essay states the central fact. `Synthesised` means it is
combined with related evidence. `Omitted` means the detail is not needed for the
pilot article; the reason is recorded.

| Fact ID | Treatment | Essay treatment or reason |
| ---: | --- | --- |
| 612 | Direct | Opens the nutrition section with adult feasibility. |
| 613 | Direct | Identifies vitamin B12 as a material constraint. |
| 614 | Direct | Explains plant-iron absorption and vitamin C. |
| 615 | Synthesised | Beans and pulses are mentioned without reproducing a separate protein list. |
| 616 | Direct | Names the nutrients requiring particular attention. |
| 617 | Direct | Qualifies the long-term health evidence. |
| 618 | Direct | Separates vegan ingredients from overall nutritional quality. |
| 619 | Synthesised | Explains why fortification matters without listing every recommended nutrient twice. |
| 620 | Synthesised | Represents the special care required for young children; detailed accepted drink types are omitted. |
| 621 | Direct | Notes that soya generally provides more protein than almond or oat drinks. |
| 622 | Direct | Includes the total- and hip-fracture association. |
| 623 | Direct | Explains why the observational result is not causal proof. |
| 624 | Direct | Includes the opposing heart-disease and stroke associations. |
| 625 | Direct | Includes the processed-meat classification and its proper interpretation. |
| 626 | Direct | Distinguishes processed meat, red meat and other animal products. |
| 627 | Direct | States the climate and health co-benefit conclusion. |
| 628 | Direct | Limits that conclusion to relevant circumstances rather than food-insecure populations. |
| 629 | Direct | Includes the modelled 3.1-billion-hectare land reduction. |
| 630 | Direct | Includes the modelled 6.5-billion-tonne annual emissions reduction. |
| 631 | Direct | Explains variation by species, production and supply chain. |
| 632 | Synthesised | Lists the life-cycle boundary to prevent a food-miles interpretation. |
| 633 | Direct | Gives the livestock sector's approximate emissions share. |
| 634 | Direct | Briefly explains enteric methane. |
| 635 | Synthesised | Complementary amino acids are stated without a separate technical discussion. |
| 636 | Direct | Establishes the scale of slaughter. |
| 637 | Direct | Pairs recorded compliance with what the statistic cannot measure. |
| 638 | Direct | Uses cage area as one concrete illustration rather than a standalone subsection. |
| 639 | Direct | Contrasts permitted or common systems with scientific welfare advice. |
| 640 | Direct | States the World Health Organization antibiotic recommendation. |
| 641 | Direct | Includes improvement in UK antibiotic sales and its evidential limit. |
| 642 | Direct | Preserves the proposition's individual-feasibility qualification. |
| 643 | Direct | Forms the conclusion separating evidence from moral judgement. |

This draft happens to represent all 32 facts, but it does not establish that
future essays must do so. Eight are condensed into shared passages and several
fine details are deliberately omitted. On another bank, a supporting item could
properly be omitted altogether. The governing requirement should be coverage of
foundational issues and material counterevidence, not a 100% item count.

## Presentation copy

The pilot uses one canonical article body. Only its introduction and calls to
action vary by presentation.

### Informed Opinion

**Link:** Explore the evidence

**Introduction:**

> Examine the principal evidence relevant to this proposition: nutritional
> feasibility and uncertainty, health outcomes, climate and land use, animal
> welfare and public-health effects. The evidence can clarify likely
> consequences, but it cannot determine the final moral judgement.

**Calls to action:**

- Test your understanding in the knowledge check.
- Register or revise your opinion.
- Inspect the complete fact bank and its sources.

### What's Your View?

**Link:** Get the background

**Introduction:**

> Can a vegan diet keep people healthy? How much difference could it make to
> emissions and animals—and what are the important catches? Here is a clear look
> at the evidence before you decide where you stand.

**Calls to action:**

- Think you've got the main facts? Try the questions.
- Give your view or see whether it has changed.
- Dig into the sources behind the article.

The conversational framing changes, but neither presentation receives a
different fact, qualification, citation or conclusion.

## Pilot conclusions

1. A fact bank can support a coherent essay without mechanically reproducing
   question-and-answer form.
2. Importance, specialist knowledge and answerability help identify gateway
   candidates but do not replace an explicit editorial gateway judgement.
3. The current sequencing implementation does not put gateway facts first.
4. Complete item coverage is neither necessary nor a useful quality target.
   Foundational-issue and counterevidence coverage are better safeguards.
5. One canonical body with site-specific framing is sufficient for this pilot.
   Two independently maintained essays would add drift risk without a
   demonstrated reader benefit.
6. Essay publication will require durable claim-to-fact provenance and stale
   content warnings when linked facts change or are withdrawn.

