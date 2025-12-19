module DayEight = struct
  let x (index: int * int) = snd index
  let y (index: int * int) = fst index

  let next_index (i: int * int): int * int =
    if (x i) < 98 then (y i, (x i)+1) else ((y i)+1, 0)
  
  let north_index (i: int * int): (int * int) option = 
    if (y i) <= 0 then None else Some ((y i)-1, x i)
  let south_index (i: int * int): (int * int) option = 
    if (y i) >= 98 then None else Some ((y i)+1, x i)
  let east_index (i: int * int): (int * int) option = 
    if (x i) >= 98 then None else Some (y i, (x i)+1)
  let west_index (i: int * int): (int * int) option = 
    if (x i) <= 0 then None else Some (y i, (x i)-1)
  
  let get_height (map: char list list) (index: int * int): int = 
    int_of_char (List.nth (List.nth map (y index)) (x index))
    
  let rec is_visible_north (map: char list list) (index: int * int) (height: int): bool = 
    match north_index index with
    | Some i ->
      if get_height map i < height then
        is_visible_north map i height
      else false
    | None ->
      true
  let rec count_visible_north (map: char list list) (index: int * int) (height: int) (count: int): int = 
    match north_index index with
    | Some i ->
      if get_height map i < height then
        count_visible_north map i height (count + 1)
      else count + 1
    | None ->
      count
  
  let rec is_visible_south (map: char list list) (index: int * int) (height: int): bool =
    match south_index index with
    | Some i ->
      if get_height map i < height then
        is_visible_south map i height
      else false
    | None ->
      true
  let rec count_visible_south (map: char list list) (index: int * int) (height: int) (count: int): int = 
    match south_index index with
    | Some i ->
      if get_height map i < height then
        count_visible_south map i height (count + 1)
      else count + 1
    | None ->
      count
  
  let rec is_visible_east (map: char list list) (index: int * int) (height: int): bool = 
    match east_index index with
    | Some i ->
      if get_height map i < height then
        is_visible_east map i height
      else false
    | None ->
      true
  let rec count_visible_east (map: char list list) (index: int * int) (height: int) (count: int): int = 
    match east_index index with
    | Some i ->
      if get_height map i < height then
        count_visible_east map i height (count + 1)
      else count + 1
    | None ->
      count
  
  let rec is_visible_west (map: char list list) (index: int * int) (height: int): bool = 
    match west_index index with
    | Some i ->
      if get_height map i < height then
        is_visible_west map i height
      else false
    | None ->
      true
  let rec count_visible_west (map: char list list) (index: int * int) (height: int) (count: int): int = 
    match west_index index with
    | Some i ->
      if get_height map i < height then
        count_visible_west map i height (count + 1)
      else (count + 1)
    | None ->
      count
  
  let is_visible (map: char list list) (index: int * int): int = 
    let height = get_height map index in
    if (is_visible_north map index height ||
        is_visible_south map index height ||
        is_visible_east map index height ||
        is_visible_west map index height) then 1 else 0
  
  let calc_score (map: char list list) (index: int * int): int =
    let height = get_height map index in
    count_visible_north map index height 0 * count_visible_south map index height 0 * count_visible_east map index height 0 * count_visible_west map index height 0
  
  let rec count_visible_from_edges (map: char list list) (total_visible: int) (index: int * int): int = 
    (* let () = print_endline ((string_of_int (y index)) ^ ":" ^ (string_of_int (x index))) in *)
    if y index < 99 then count_visible_from_edges map (total_visible + (is_visible map index)) (next_index index) else total_visible
  
  let rec calc_max_scenic_score (map: char list list) (prev_max: int) (index: int * int): int = 
    if y index < 99 then calc_max_scenic_score map (max prev_max (calc_score map index)) (next_index index) else prev_max
  
  let main (input: string) = 
    let lines_of_input = Str.split (Str.regexp "\n") input in
    let map: char list list = List.map (fun a -> (List.of_seq (String.to_seq a))) lines_of_input in

    let output = (string_of_int (count_visible_from_edges map 0 (0, 0)), string_of_int (calc_max_scenic_score map 0 (0, 0))) in

    print_endline (snd output)
end