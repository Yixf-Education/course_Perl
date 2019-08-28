#!/bin/bash

perl -ne 'if(/^>/){($id)=split; $id=~s/>//; print "$id\n"}' a.fa b.fa c.fa
