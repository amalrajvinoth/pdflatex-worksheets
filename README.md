# Grade 2 Worksheets (LaTeX)

A collection of printable worksheets for Grade 2 students, built with LaTeX.

## Worksheets

| File | Description |
|------|-------------|
| `worksheet-g2-u100.tex` | Addition & subtraction under 100 (no carry, light carry, full carry/borrow) |
| `worksheet-g2-advanced.tex` | Advanced addition & subtraction (up to 200, multi-step problems) |
| `worksheet-g2-wordtest-long-e.tex` | Word test for long "E" sounds (ee, ea, e-e patterns) |

## Word Test: Long E

Covers 13 words: **been, seed, sheep, sweet, cheese, bean, steam, stream, seat, meat, please, these, complete**

Includes 10 activity types:
1. Word Bank (Practice)
2. Write Each Word
3. Traditional Dictation
4. Missing Letters
5. Jumbled Letters
6. Multiple Choice
7. Homophone / Meaning Check
8. Sentence Completion
9. Error Correction
10. Word Shape / Visual Memory

## Build

Requires a LaTeX distribution (e.g., TeX Live, MacTeX).

```bash
# Build a single worksheet
latexmk -pdf worksheet-g2-wordtest-long-e.tex

# Build all worksheets
latexmk -pdf *.tex

# Clean build artifacts
latexmk -c
```

## License

MIT
