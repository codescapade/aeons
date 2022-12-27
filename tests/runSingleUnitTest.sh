#!/bin/bash
node ../lib/Kha/make node --projectfile singleUnitTest.js
cd build/node
node kha.js
cd ../..