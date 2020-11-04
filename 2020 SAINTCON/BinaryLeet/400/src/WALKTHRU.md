Debugging the binary will show offset for 20 characters. Ths passphrase can be decoded with some scripting and automation, or manually trying to break the code. The lucky few will recognize the hex from BL300 is more than just some random hex chars... :)

1) Convert the hex from the flag in BL300 for the passphrase:
flag{6865726520697320796f757220736563726574}
flag{here is your secret}

2) input: here is your secret for the vault.dmp
Passphrase: here is your secret
flag{you_found_the_flag!}

Hint: You'll know you have the correct flag when you see it

