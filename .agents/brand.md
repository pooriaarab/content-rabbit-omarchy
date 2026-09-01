# Content Rabbit brand

This repository provides the Content Rabbit capture plugin for Omarchy.
Use this guide with `.agents/design.md` for user-facing changes.

## Identity

- Use the product name **Content Rabbit**.
- Use `CR` only in the compact bar button.
- Use `io.github.pooriaarab.content-rabbit` as the plugin identifier.
- Describe the plugin as a fast capture path for social post ideas.
- Keep the plugin distinct from the Content Rabbit web application.

## Product promise

The plugin helps people capture an idea without leaving their current task.
People can paste text, save a local draft, or copy a draft before opening the
Content Rabbit application.

Drafts stay in the user's Omarchy state directory. The plugin does not read,
store, or transmit API keys. Do not imply that it publishes content itself.

## Voice

Use short action labels. Current labels include “Capture,” “Saved,” “Paste,”
“Save locally,” “Copy and open,” “Open,” and “Delete.”

Status messages state the result and next action. Keep them direct. Do not add
marketing language inside the compact panel.

## Visual boundary

This plugin has no independent logo, palette, or typeface in the repository.
It uses the `CR` text mark and inherits visual tokens from Omarchy.

Do not invent Content Rabbit colors inside this plugin. Do not copy styles from
the separate web application. The plugin must remain native to its host bar.

## Distribution boundary

This repository packages an Omarchy plugin. It does not own or deploy the
Content Rabbit website that it opens.
