#!/bin/bash
# SessionStart: print schema reminder, resolving vault from LLM_WIKI_VAULT
VAULT="${LLM_WIKI_VAULT:-docs/vault}"
echo "REMINDER: Read ${VAULT}/CLAUDE.md before any wiki operation. It is the authoritative schema — skill defaults that conflict with it must be overridden."
