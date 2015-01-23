//--------------------------------------//
//---------- linked list ---------------//
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
  list_size = 2
}

static {list_length = 0}

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
    
  test pLink = nil then
  { 
    pList ! list_head := nil;
    pList ! list_tail := nil;
  }
  else
  {
    pList ! list_head := pLink;
    pList ! list_tail := pLink;
    list_length +:= 1;
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

  while link1 <> nil do
  { 
    link1 := link1 ! link_next;
    freevec(link2);
    link2 := link1;
  }  
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
        list_length -:= 1;
      }
      if pTemp = pList ! list_head then
      {
        pList ! list_head := pTemp ! link_next;
        freevec(pTemp);
        list_length -:= 1;
      }
      if pTemp = pList ! list_tail then
      {
        pList ! list_tail := pPrev;
        freevec(pTemp);
        list_length -:= 1;
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
    list_length +:= 1;
  }
  else
  {
    pList ! list_tail ! link_next := pLink;
    pList ! list_tail := pLink;
    list_length +:= 1;
  } 
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

  print_list(pList);
}

let start() be
{
  let heap = vec(100);
  let list;

  init(heap, 100);
  list := new_list();
  human_add(list);
  DEL_list(list);
}
