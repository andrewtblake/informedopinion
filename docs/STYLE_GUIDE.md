# Informed Opinion interface system

This document is the single visual standard for the application. New pages
must use the shared `ui-*` primitives and tokens in
`app/assets/stylesheets/application.css`. Page-specific selectors may arrange
content, but must not establish another palette, type scale, surface treatment,
control shape, shadow system, or topic identity.

## Character

The interface is sober, judicious, clean and concise: closer to a serious
newspaper or reference work than a promotional consumer application. Interactive
work such as a quiz may command more attention through hierarchy and state, not
through a different visual language.

## Canonical foundations

- Background: warm paper (`--ui-page-background`).
- Text: ink and muted blue-grey (`--ink`, `--muted`).
- Interactive accent: one dark teal (`--ui-accent`). Topic-specific colours are
  not part of the interface system.
- Type: Inter, Avenir Next, Segoe UI, then sans-serif.
- Rules: fine grey-green rules, with a dark double rule for mastheads.
- Corners: two pixels for surfaces and controls.
- Shadows: one restrained surface shadow; flat panels have none.

## Shared primitives

- `ui-page`: canonical page background and vertical rhythm.
- `ui-masthead`: page title, introduction and double rule.
- `ui-sheet`: the principal raised working surface.
- `ui-sheet-emphasis`: the shared accent rule for a focused working surface.
- `ui-panel`: a flat secondary surface.
- `ui-kicker`: compact uppercase contextual label.
- `ui-choice`: selectable answer or opinion row.
- `ui-action-footer`: ruled area containing the primary next action.
- `button` / `ui-button`: canonical square-cornered controls.

Use these classes in the view rather than recreating their declarations under a
page name. A page-specific class can set width, grid columns, sticky behaviour,
or the geometry of a unique visualisation.

## Topic identity

Topics are identified by title, proposition, category and tags—not colour.
Selected answers, progress, links and focus states all use the single interface
accent. Correct and incorrect feedback may use semantic success and error colour,
because those colours communicate state rather than topic identity.

## Interaction and accessibility

- Never truncate propositions, questions, answers or explanations.
- Keep hit areas generous even when the visual treatment is restrained.
- Use visible keyboard focus and preserve native form semantics.
- Put primary workflow actions in `ui-action-footer` where practical.
- Desktop minimum heights may stabilise repeated workflows, but must be removed
  on narrow screens and must never clip variable content.
