#!/bin/bash
node ../lib/Kha/make node --projectfile unitTests.js
cd build/node
node kha.js
cd ../..