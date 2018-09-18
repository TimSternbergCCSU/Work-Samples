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

int main1()
{
  Node *headPtr = NULL;
  insertFirst( &headPtr, 99 );
  traverse( headPtr );
  freeList( headPtr );
  return 1;
}


int main2()
{
  Node *headPtr = NULL;
  insertFirst( &headPtr, 99 );
  insertFirst( &headPtr, 88 );
  insertFirst( &headPtr, 77 );

  traverse( headPtr );
  freeList( headPtr );
  return 1;
}

int main3()
{
  Node *headPtr = NULL;
 
  int j;
  for ( j=0; j<13; j++ )
    insertFirst( &headPtr, j );

  traverse( headPtr );
  freeList( headPtr );
  return 1;
}

int countTarget(Node *start, int target)
{
  int occurances = 0;
  while (start != NULL)
  {
    if (start->value == target)
      occurances++;
      start = start->link;
    }
  return occurances;
}

Node *deleteFirst(Node **ptrToHeadPtr)
{
  if (*ptrToHeadPtr == NULL)
    return NULL;
  else if ( (*ptrToHeadPtr)->link == NULL )
  {
    free(*ptrToHeadPtr);
    ptrToHeadPtr = NULL;
    return NULL;
  }
  else
  {
    NODE *temp = *ptrToHeadPtr;
    *ptrToHeadPtr = (temp->link);
    free(temp);
    return *ptrToHeadPtr;
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

  traverse( headPtr ); printf("\n");
  
  Node *whereItIs;
  
  if ( whereItIs = search( headPtr, 25) )
    printf("FOUND: %d\n", whereItIs->value );
  else
    printf("not present\n");
  
  //freeList( headPtr );
  
  fflush(stdout);
  printf("%d\n",countTarget(headPtr, 25));
  fflush(stdout);
  printf("%d\n",deleteFirst(&headPtr)->value);
  fflush(stdout);
  traverse(headPtr); printf("\n");
  
  return 1;
}
