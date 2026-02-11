---
argument-hint: [code path or concept]
description: Explain code with analogies, ASCII diagrams, or HTML slides
---

Explain $ARGUMENTS using visual aids. Choose the best format based on complexity:

## For code explanations, always include:

1. **Start with an analogy**: Compare the code to something from everyday life
2. **Draw a diagram**: Use ASCII art to show the flow, structure, or relationships
3. **Walk through the code**: Explain step-by-step what happens
4. **Highlight a gotcha**: What's a common mistake or misconception?

## For complex systems or when asked for "slides" or "presentation":

Generate a single self-contained HTML file with:
- Multiple slides/sections with navigation
- Animated transitions or interactive elements
- ASCII diagrams converted to visual diagrams where helpful
- Code snippets with syntax highlighting
- Save to `explanations/<topic>-explained.html` and open in browser

## Guidelines

- Keep explanations conversational
- For complex concepts, use multiple analogies
- Diagrams should clarify relationships, data flow, or state changes
- When explaining protocols or architectures, show the sequence of operations
