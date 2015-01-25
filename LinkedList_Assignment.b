//--------------------------------------//
//--- linked list & tree assignment  ---//
//                                      //
//  This code is a simple linked list   //
//  that consists of a list "object'    //
//  that encapsulates a series of links //
//  with next pointers. The list has    //
//  a pointer to the head and tail      //
//  to make adding to the list easier.  //
//  There is also a static variable     //
//  to hold on to the size of the list. //
//                                      //
//  The tree is taken from Murrell's    //
//  BCPL documentation and a list->     //
//  tree conversion function has been   //
//  added.                              //
//                                      //
//  Written for Dr. Murrell's Operating //
//  Systems class by Davis Sprague      //
//  for January 31st 2015.              //
//                                      //
//--------------------------------------//
//--------------------------------------//

import "io"

//named constants to make parts of the
//links easily accessible.
manifest
{
  link_data = 0,
  link_next = 1,
  link_size = 2,

  list_head = 0,
  list_tail = 1,
  list_length = 2,
  list_size = 3,

  node_data = 0,
  node_left = 1,
  node_right = 2,
  sizeof_node = 3
}

//static {node_data, node_left, node_right, sizeof_node}

let new_node(x) be
{
  let p = newvec(sizeof_node);
  p ! node_data := x;
  p ! node_left := nil;
  p ! node_right := nil;
  resultis p;
}

let add_to_tree(ptr, value) be
{
  if ptr = nil then
    resultis new_node(value);
  test value < ptr ! node_data then
    ptr ! node_left := add_to_tree(ptr ! node_left, value)
  else
    ptr ! node_right := add_to_tree(ptr ! node_right, value);
  resultis ptr; 
}

let tree_print(ptr) be
{
  if ptr = nil then return;
  tree_print(ptr ! node_left);
  out("%d ", ptr ! node_data);
  tree_print(ptr ! node_right);
}


//Takes a list as a parameter, then
//converts that list to a tree and
//returns the tree, leveraging the
//Murrell's add_to_tree function.
let tree_from_list(pList) be
{
  let link1 = pList ! list_head;
  let Tree = nil;

  while link1 <> nil do
  {
    Tree := add_to_tree(Tree, link1 ! link_data);
    link1 := link1 ! link_next;
  } 

  resultis Tree;
}

//Creates a new link, expecting an 
//integer in the parameter field.
//Sets the next pointer to nil
//and returns the result.

let new_link(nData) be
{
  let ptr = newvec(link_size);
  ptr ! link_data := nData;
  ptr ! link_next := nil;
  resultis ptr;
}


//Creates a new list, with an 
//optional parameter that expects
//a single link with which to set 
//as the head of the list

let new_list(pLink) be
{
  let pList = newvec(list_size);
  
  pList ! list_length := 0;    
  test pLink = nil then
  { 
    pList ! list_head := nil;
    pList ! list_tail := nil;
  }
  else
  {
    pList ! list_head := pLink;
    pList ! list_tail := pLink;
    pList ! list_length +:= 1;
  }
  resultis pList;
}


//Frees the memory of the entire
//list link by link, then removes
//the list vector

let DEL_list(pList) be
{
  let link1 = pList ! list_head;
  let link2 = link1;
  let i;

  for i = 0 to pList ! list_length do
  { 
    link1 := link1 ! link_next;
    freevec(link2);
    link2 := link1;
  }  
  pList ! list_length := 0;
  freevec(pList);
}


//Takes a pointer to a single link
//and prints the data held in the link

let print_link(pLink) be
{
  out("%d ",pLink ! link_data);
}

//Takes a pointer to the head of the
//list and prints the data in every
//link in the list

let print_list(ptr) be
{
  let temp = ptr ! list_head;
  let i;

  for i = 1 to list_length do
  {
    print_link(temp);
    temp := temp ! link_next;
  }
  out("\n");
}


//Removes the link specified by
//the parameter nPos from
//the list and reduces the static
//global list_length by one

let remove_list_pos(pList, nPos) be
{
  let i, temp = pList ! list_head;
  let prev = nil;

  for i = 1 to nPos do
  {
    prev := temp;
    temp := temp ! link_next;
  }

  prev ! link_next := temp ! link_next;
  freevec(temp);
  pList ! list_length -:= 1; 
}

//Removes the link specified by
//parameter nData from the list
//and reduces the static global
//list_length by one

let remove_link(pList, nData) be
{
  let pTemp = pList ! list_head;
  let pPrev = nil;

  while pTemp <> nil do
  {
    if pTemp ! link_data = nData then
    {
      if pPrev <> nil then
      {
        pPrev ! link_next := pTemp ! link_next;
        freevec(pTemp);
        pList ! list_length -:= 1;
      }
      if pTemp = pList ! list_head then
      {
        pList ! list_head := pTemp ! link_next;
        freevec(pTemp);
        pList ! list_length -:= 1;
      }
      if pTemp = pList ! list_tail then
      {
        pList ! list_tail := pPrev;
        freevec(pTemp);
        pList ! list_length -:= 1;
      }
    }
    pPrev := pTemp;
    pTemp := pTemp ! link_next;
  }
}


//Adds the link pLink to the list
//ptr by setting the next pointer
//at the end of the list equal to
//pLink, then returns the pointer
//to the head of the list.

let add_link(pList, pLink) be
{
  test pList ! list_head = pList ! list_tail /\ pList ! list_head = nil then
  {
    pList ! list_head := pLink;
    pList ! list_tail := pLink;
    pList ! list_length +:= 1;
  }
  else
  {
    pList ! list_tail ! link_next := pLink;
    pList ! list_tail := pLink;
    pList ! list_length +:= 1;
  } 
}

//reverses the list by creating
//a second list, then assigning
//the second list to the pointer
//to the first list. Also deletes
//the old list. Takes a list as
//a parameter

let reverse_list(pList) be
{
  let newList = new_list(pList ! list_tail);
  let i, temp = pList ! list_head;

  for i = 1 to pList ! list_length do
  {
    add_link(newList, temp);
    temp := temp ! link_next;
  }
  DEL_list(pList);
  pList := newList;
}

let human_add(pList) be
{
  let nHoomanInput = 0;

  out("\n\nEnter the numbers you wish to store in the list, separated by returns.\n");
  out("When you are finished, enter the number '-1'.\n\n");
  
  nHoomanInput := inno();
  while nHoomanInput <> -1 do
  {
    add_link(pList, new_link(nHoomanInput));
    nHoomanInput := inno();
  }
}

let start() be
{
  let heap = vec(1000);
  let list, tree;

  init(heap, 1000);
  list := new_list();
  human_add(list);
  //reverse_list(list);
  tree := tree_from_list(list);
  tree_print(tree);   
}
