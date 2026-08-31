# Content Rabbit for Omarchy

Capture social ideas from the Omarchy Quattro bar.

The panel captures text, pastes your focused clipboard, and saves local drafts.
It copies a selected draft to the clipboard before opening Content Rabbit. It
does not read, store, or transmit API keys.

## Install

```sh
omarchy plugin add https://github.com/pooriaarab/content-rabbit-omarchy.git \
  --enable --yes
```

Review the source when Omarchy prompts you. The plugin runs inside the user’s
Omarchy shell.

## Use

Click `CR` in the bar. Write an idea, then select **Copy and open**. The draft
is copied to your clipboard for a deliberate paste into Content Rabbit.

Use **Save locally** to keep an idea on this device. The bar shows the number
of saved drafts. Local drafts are stored at
`~/.local/state/omarchy/content-rabbit-drafts.json`.

### Keyboard shortcut

Add this Hyprland binding to open the panel from anywhere:

```ini
bind = SUPER SHIFT, R, exec, omarchy-shell shell toggle io.github.pooriaarab.content-rabbit '{}'
```

Inside the capture field, `Ctrl+Enter` copies the text and opens Content Rabbit.

## Remove

```sh
omarchy plugin remove io.github.pooriaarab.content-rabbit
```

## Dependencies

- Omarchy Quattro with its standard Quickshell runtime.
- A default browser that can open HTTPS URLs.
- The standard Omarchy state directory.

## License

MIT. See [LICENSE](LICENSE).
