#!/bin/bash

# << 1s
time perl f_cache.pl 40

# << 1s
time perl f_module.pl 40

# ~ 1m
time perl f_slow.pl 40
