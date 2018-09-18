private void SegmentedInsertionSort(AnyType[] array, int N, int h)
{
	int numOfComparisons=0, numOfExchanges=0;
	
	AnyType temp;
	for (int i = h+1; i < N; i++) {
		int j = i-h;

		while (j > 0) {
			numOfComparisons++; // Stating that we made a comparison
			if (array[j].isBetterThan(array[j+h])) {
				// Swapping j and h+j
				temp = array[j];
				array[j] = array[h+j];
				array[h+j] = temp;
				
				
				j -= h; // Decrimenting j by h
				
				
				numOfExchanges++; // Stating that we made an exchange
			}
			else
				j = 0;
		}
	}
}

public void Sort(AnyType[] array) {
	int h = array.length / 2;
	while (h > 0) {
		SegmentedInsertionSort(array, array.length, h);
		h = h / 2;
	}
}