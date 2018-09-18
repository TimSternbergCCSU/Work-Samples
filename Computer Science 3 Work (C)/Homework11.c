/* CS 153 PROGRAM 11 Linked Lists
 AUTHOR: Tim Sternberg
 DATE: 5/2/17
 DESCRIPTION: Write additional linked list functions so supplement linkedList.c
*/

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <time.h>

struct NODE
{
    struct NODE *link;
    int value;
};

typedef struct NODE Node;

int countNodes( Node *p )
{
  int count = 0;
  while ( p )
  {
    count++ ;
    p = p->link;
  }    
  return count;
}

Node *search( Node *p, int target)
{
  while ( p && target != p->value )
  {
    p = p->link;
  }
  return p;
}

void traverse( Node *p )
{
    while (p != NULL)
    {
        printf( "%3d ", p->value );
        p = p->link;
    }
}

void freeList( Node *p )
{
    Node *temp;

    while (p != NULL)
    {
        temp = p;
        p = p->link;
        free( temp );
    }
}

/* Insert a node containing val at the head of the linked list */
Node *insertFirst( Node **ptrToHeadPtr, int val )
{
    Node *node = (Node *)malloc( sizeof( Node ) );

    /* Return NULL if memory allocation failed */
    if (!node) return NULL;

    node->value = val;
    node->link = *ptrToHeadPtr;
    *ptrToHeadPtr = node;
    return node;
}

int countTarget(Node *start, int target)
{
    int occurances = 0; /* Initializing to 0 means if either the target does not occur or the linked list is empty it will still return 0 */
    while (start != NULL)
    {
        if (start->value == target)
            occurances++;
  
        start = start->link; /* Advancing the pointer */
    }
    return occurances;
}

Node *deleteFirst(Node **ptrToHeadPtr)
{
    if (*ptrToHeadPtr == NULL) /* First of all, if the list in empty, then return null */
        return NULL;
    else if ( (*ptrToHeadPtr)->link == NULL ) /* If this is a 1 node linked list, then delete the node and return null */
    {
        free(*ptrToHeadPtr); /* Still need to free the memory */
        *ptrToHeadPtr = NULL;
        return NULL;
    }
    else /* It must be a linked list with 2 or more nodes */
    {
        NODE *temp = *ptrToHeadPtr; /* The node to delete */
        *ptrToHeadPtr = temp->link; /* Redefining what the first node is */
        free(temp);
        return *ptrToHeadPtr; /* Returning the new first node */
    }
}

Node *insertLast( Node **ptrToHeadPtr, int val )
{
    Node *newLast = (Node *)malloc( sizeof( Node ) ); /* Allocating memory for the new node */
 
    if (!newLast) return NULL;  /* Return NULL if memory allocation failed */
  
    newLast->value = val;
    newLast->link = NULL; /* It will be the last node, so it won't have a link to point to */

    Node *oldLast = *ptrToHeadPtr;
    if (oldLast == NULL) /* This was an empty list */
        *ptrToHeadPtr = newLast; /* First node is now the node we wanted to insert */
    else
    {
        while (oldLast->link != NULL) /* Looking for the last node */
            oldLast = oldLast->link; /* Advancing the pointer if it wasn't the last node */

        oldLast->link = newLast;
    }

    return newLast;
}

Node *deleteLast( Node **ptrToHeadPtr )
{
    if (*ptrToHeadPtr == NULL) /* If an empty list */
        return NULL;
    else if ( (*ptrToHeadPtr)->link == NULL ) /* If it was a one node linked list */
    {
        free(*ptrToHeadPtr);
        *ptrToHeadPtr = NULL;
        return NULL;
    }
    else
    {
	    NODE *newLast = *ptrToHeadPtr;
        while (newLast->link->link != NULL) /* We can safely assume that the first node is pointing to something, since we've already checked if this is a one node linked list */
            newLast = newLast->link; /* Advancing the pointer until the SECOND to last node, which will be our new last node */
  
        free(newLast->link); /* Free the memory which had the last node */
	    newLast->link = NULL; /* The last node has no node to point to, so we set it to null */

        return newLast;
    }
}

int main()
{
    Node *headPtr = NULL;
 
    srand( time(NULL) );
    int j;
    for ( j=0; j<25; j++ )
    {
        insertFirst( &headPtr, rand()%100 );
    }

    printf("Original linked list: "); traverse( headPtr ); printf("\n");
  
    printf("25 occured %d times\n",countTarget(headPtr, 25));
	printf("%d\n",(*headPtr).value);
    printf("Deleted first node. Node with value %d is now the head\n",deleteFirst(&headPtr)->value);
    printf("Inserted a node with value %d as the first.\n",insertFirst( &headPtr, 99 )->value);
    printf("Deleted the last node. New last node has value %d.\n",deleteLast(&headPtr)->value);
	
    printf("Altered linked list: "); traverse(headPtr); printf("\n");
  
    return 1;
}