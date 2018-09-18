#define NAMESIZE 132

typedef struct
{
  int hitPoints;
  int maxHitPoints;
  int strength;
  int maxStrength;
  int potions;
  int gold;
  char name[NAMESIZE];
} actor;
