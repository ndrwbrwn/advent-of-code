module DayTwo = struct 
  let main (input: string) = 
    let lines_of_input: string list = Str.split (Str.regexp "\n") input in

    let round_total: int list = List.map (
      fun a: int -> (
        let score = (
          match a with
          | ("X A") -> 0 + 3 (* lose vs rock *)
          | ("X B") -> 0 + 1 (* lose vs paper *)
          | ("X C") -> 0 + 2 (* lose vs scissors *)
          | ("Y A") -> 3 + 1 (* draw vs rock *)
          | ("Y B") -> 3 + 2 (* draw vs paper *)
          | ("Y C") -> 3 + 3 (* draw vs scissors *)
          | ("Z A") -> 6 + 2 (* win vs rock *)
          | ("Z B") -> 6 + 3 (* win vs paper *)
          | ("Z C") -> 6 + 1 (* win vs scissors *)
          | _ -> 0
        ) in
        score
      )
    ) lines_of_input in
    
    List.fold_left (+) 0 round_total
end