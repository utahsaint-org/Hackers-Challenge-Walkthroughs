# ButterBrute

> The name of the game on this one is using a wordlist. You can write something yourself or figure out how to load it into hashcat. Good Luck!

Attached to the challenge were two files:

- [password_vault.bcup](./password_vault.bcup)
- [wordlist.7z](./wordlist.7z)

## Solution

One solution to this challenge was to discover the [butterbrute](https://github.com/fkasler/butterbrute/tree/main) repo. Butterbrute is a bcup vault brute forcing utility developed with rust. After cloning down the repo, you can install it by running `cargo install --release` from the repo root.


```
❯ cd butterbrute

❯ cargo build --release                                                                                                                                                                                                                             09:19:18 AM
    Updating crates.io index
  Downloaded lazy_static v1.4.0
  Downloaded hex v0.4.3
  Downloaded either v1.8.1
  Downloaded unicode-width v0.1.10
  ...

❯ ls -l target/release/butterbrute                                                                                                                                                                                                                  09:26:20 AM
-rwxr-xr-x@ 1 v01d  v01d  1017824 Oct 25 09:19 target/release/butterbrute
```
