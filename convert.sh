#!/bin/bash

# Shell script to convert 'csv' folder from ISO-8859-1 to UTF-8

for i in csv/*/*.csv; do
    iconv -f ISO-8859-1 -t UTF-8 "${i}" -o tmp; mv tmp "${i}";
done
