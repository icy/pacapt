#!/usr/bin/env groovy

// Author : Ky-Anh Huynh
// Date   : 2018 July 08
// License: MIT

@Library("icy@master")

def icyUtils = new org.icy.Utils()

try {
  node {
    checkOut("clean")

    buildInfo()

    stage("tests") {
      sh '''
        make tests
      '''
    }
  }
}
catch (exc) {
  currentBuild.result = currentBuild.result ?: "FAILED"
  echo "Caught: ${exc}"
  throw exc
}
finally {
  echo "Finally."
}
