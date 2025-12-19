module DayThree = struct
  let rec condense_groups = fun (a: char list list) (out: (char list * char list * char list) list) (n: int) ->
    if n >= List.length a then out else
      condense_groups a ((List.nth a n, List.nth a (n+1), List.nth a (n+2)) :: out) (n + 3)

  let rec condense = fun (a: char list) (o1: char list) (o2: char list) (n: int): (char list * char list) -> 
    if n >= List.length a then (o1, o2) else
      if n < (List.length a / 2) then
        condense a ((List.nth a n) :: o1) o2 (n + 1)
      else
        condense a o1 ((List.nth a n) :: o2) (n + 1)

  let rec item_exists item lst =
    match lst with
    | [] -> false
    | head::tail -> item = head || item_exists item tail

  let rec find_common lst1 lst2 =
    match lst1 with
    | [] -> None
    | head::tail -> 
      if (item_exists head lst2) then
        Some head
      else find_common tail lst2

  let rec find_commons lst1 lst2 acc =
    match lst1 with
    | [] -> acc
    | head::tail ->
      if (item_exists head lst2) then
        find_commons tail lst2 (head :: acc)
      else
        find_commons tail lst2 acc

  let priority c = 
    if Char.code c <= 90 then
      Char.code c - 38
    else
      Char.code c - 96

  let main (input: string) = 
    let lines_of_input: string list = Str.split (Str.regexp "\n") input in
    let chars_of_input: char list list = List.map (fun (a: string): char list -> (List.of_seq (String.to_seq a))) lines_of_input in

    let rucksacks = List.map (fun (a: char list): (char list * char list) -> condense a [] [] 0) chars_of_input in

    let groups = condense_groups chars_of_input [] 0 in

    let items_in_both = List.map (fun (a: char list * char list): int -> 
      let dupe = find_common (fst a) (snd a) in
      priority (Option.get dupe)
    ) rucksacks in
  
    let items_in_all = List.map (fun (a: char list * char list * char list): int ->
      match a with
      | fst, snd, thr ->
        let dupes = find_commons fst snd [] in
        let common = find_common dupes thr in
        priority (Option.get common)
    ) groups in

    let output: int * int = (List.fold_left (+) 0 items_in_all, List.fold_left (+) 0 items_in_both) in

    print_int (fst output)
end