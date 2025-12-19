module DaySix = struct
  let get_char_option = fun (s: char list) (index: int) ->
    if index < 0 then None else Some (List.nth s index)
  
  let rec item_exists item lst =
    match lst with
    | [] -> false
    | head::tail -> item = head || item_exists item tail
  
  let rec dupes_exist lst =
    match lst with
    | [] -> false
    | head::tail -> (item_exists head tail) || dupes_exist tail
  
  let no_nones = fun l ->
    not (List.exists (fun a -> a == None) l)
  
  let rec process_chars = fun (s: char list) (index: int) -> 
    let indices = List.map (fun (a: int): int -> index - a) [0;1;2;3;4;5;6;7;8;9;10;11;12;13] in
    let last_chars = List.map (fun a: char option -> get_char_option s a) indices in
    
    if (not (dupes_exist last_chars)) && no_nones last_chars then
      index + 1
    else
      process_chars s (index + 1)

  let main (input: string) =
    let out = process_chars (List.of_seq (String.to_seq input)) 0 in
    out
end