---
argument-hint: [code path or concept]
description: Explain code with analogies, ASCII diagrams, or HTML slides
---

Explain $ARGUMENTS. Choose the best approach based on complexity:

## Step 1: Build from first principles

Start every explanation from the bottom up:

1. **Identify fundamentals**: What are the most basic concepts needed to understand this?
2. **Define terms**: Clearly define any domain-specific terminology before using it
3. **Build layer by layer**: Introduce one concept at a time, showing how each connects to the previous
4. **Show the "why"**: For each layer, explain why it exists, what problem it solves
5. **Provide a mental model**: Once the layers are built, offer a concise mental model that ties it all together

## Step 2: Make it visual

After establishing the conceptual foundation:

1. **Draw a diagram**: Use ASCII art to show flow, structure, or relationships
2. **Walk through the code**: Step-by-step what happens at runtime
3. **Highlight gotchas**: Common mistakes or misconceptions

## For complex systems or when asked for "slides" or "presentation":

Generate a single self-contained HTML file with:
- Multiple slides/sections with navigation
- Animated transitions or interactive elements
- ASCII diagrams converted to visual diagrams where helpful
- Code snippets with syntax highlighting
- Save to `.claude/explanations/<topic>-explained.html` and open in browser

## Guidelines

- Lead with precision, not analogies. Use analogies only after the core concepts are established
- Diagrams should clarify relationships, data flow, or state changes
- When explaining protocols or architectures, show the sequence of operations
- Adapt depth to the audience: skip fundamentals the user clearly already knows
