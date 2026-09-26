# Publish this repo to GitHub (personal account)

`gh` on this machine is logged into a different account. Create empty repos under **Shubhamsdr3**, then push with the personal SSH host.

## 1. Create empty private repos on GitHub

In the browser (logged in as Shubhamsdr3):

1. https://github.com/new → name `bookish-frontend` → Private → **no** README
2. https://github.com/new → name `bookish-android` → Private → **no** README

## 2. Push

```bash
cd ~/Documents/personal/bookish-frontend
git push -u origin main

cd ~/Documents/personal/bookish-android
git push -u origin main
```

Remotes are already set to `git@github.com-personal:Shubhamsdr3/...`.
