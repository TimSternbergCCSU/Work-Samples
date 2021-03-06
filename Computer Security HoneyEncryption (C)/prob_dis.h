double probability_distribution(char *plaintext) {
  int prefix[6];

  int i; for(i=0; i<6; i++) {
    prefix[i] = plaintext[i] - '0';
    int prefix_i,prefixInt = 0;
    int o; for(o=0; o<=i; o++) {
      prefixInt = prefixInt*10;
      prefixInt += prefix[o];
    }

    if((prefix_i = searchPrefixes(prefixInt)) > 0) {
      double prefixProb = 1.0/total_prob;
      int64_t randomDigs=0;
        get_randomDigs(prefix,6,plaintext,&randomDigs);
      int numInitialZeros=0; while(plaintext[6+numInitialZeros] == '0') numInitialZeros++;
      int numRandomDigs = floor(log10(abs(randomDigs))) + 1 + numInitialZeros; // len(randomDigs)
      double prob = prefixProb * pow(10,-numRandomDigs);
      return prob;
    }
  }
  printf("Invalid credit card\n");
  return -1;
}
