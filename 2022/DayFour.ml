module DayFour = struct
  let bounded (r1: (int * int)) (r2: (int * int)): bool =
    if fst r1 >= fst r2 && fst r1 <= snd r2 then
      true
    else 
      if snd r1 >= fst r2 && snd r1 <= snd r2 then
        true
      else false

  let main (input: string) = 
    let lines_of_input: string list = Str.split (Str.regexp "\n") input in

    let ranges: ((int * int) * (int * int)) list = List.map (fun (a: string): ((int * int) * (int * int)) -> (
      let x = Str.split (Str.regexp ",") a in
      let range1 = Str.split (Str.regexp "-") (List.nth x 0) in
      let range2 = Str.split (Str.regexp "-") (List.nth x 1) in

      ((int_of_string (List.nth range1 0), int_of_string (List.nth range1 1)), (int_of_string (List.nth range2 0), int_of_string (List.nth range2 1)))
    )) lines_of_input in

    let contained: int list = List.map (fun (a: (int * int) * (int * int)): int -> (
      let range1 = fst a in
      let range2 = snd a in
      if bounded range1 range2 || bounded range2 range1 then 1 else 0
    )) ranges in

    let output = List.fold_left (+) 0 contained in
    print_int output
end