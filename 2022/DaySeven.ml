module DaySeven = struct
  exception Syntax_error of string

  type 'a tree =
  | Leaf of {
    mutable data: 'a;
    parent: 'a tree;
  }
  | Twig of {
    mutable data: 'a;
    mutable children: 'a tree list;
    parent: 'a tree option;
  }
  | Empty

  let print_tree (node: (string * int) tree) =
    let rec print_node (depth: int) (node: (string * int) tree) = 
      let () = for _ = 0 to depth * 2 do
        print_char ' '
      done in
      match node with
      | Leaf {data = d; _} ->
        print_endline ("File " ^ fst d ^ ": " ^ string_of_int (snd d))
      | Twig {data = d; children = c; _} ->
        let () = print_endline ("Folder " ^ fst d ^ ": " ^ string_of_int (snd d)) in
        List.iter (print_node (depth + 1)) c
      | _ -> ()
    in
    print_node 0 node
  
  let get_node_size (node: (string * int) tree): int option = 
    match node with
    | Leaf l ->
      Some (snd l.data)
    | Twig t ->
      if snd t.data != -1 then 
        Some (snd t.data)
      else 
        None
    | _ -> None

  let get_node_name = fun (node: 'a tree): string option ->
    match node with
    | Twig t ->
      Some (fst t.data)
    | Leaf l ->
      Some (fst l.data)
    | _ -> None

  let folder_name_match = fun (test: string) (node: 'a tree): bool ->
    match node with
    | Twig {data = (name, _); children = _; parent = _} ->
      test = name
    | _ -> 
      false

  let rec goto_head node = 
    match node with
    | Empty ->
      node
    | Leaf {data = _; parent = p} ->
      goto_head p
    | Twig {data = _; children = _; parent = parent} ->
      match parent with
      | Some not_head ->
        goto_head not_head
      | None ->
        node

  let commandline_cd = Str.regexp {|\$ cd \(.*?\)|}
  let commandline_ls = Str.regexp {|\$ ls|}
  let outputline_dir = Str.regexp {|dir \(.*?\)|}
  let outputline_file = Str.regexp {|\([0-9]+\) \(.*?\)|}

  let rec process_lines_into_tree (lines: string list) (index: int) (output: (string * int) tree): (string * int) tree = 
    if index >= List.length lines then goto_head output else

    let next_line = List.nth lines index in

    if Str.string_match commandline_cd next_line 0 then
      (* find the dir we're CD'ing to and put that as our output node *)
      let new_output = match output with
      | Empty ->
        Twig {data = (Str.matched_group 1 next_line, -1); children = []; parent = None}
      | Leaf(_) ->
        raise (Syntax_error ("CD command from leaf node! @" ^ (string_of_int index)))
      | Twig {data = _; children = c; parent = p} ->
        let folder_name = Str.matched_group 1 next_line in
        if folder_name = ".." then Option.get p else
        List.hd (List.filter (folder_name_match folder_name) c)
      in
      
      process_lines_into_tree lines (index+1) new_output
    else if Str.string_match commandline_ls next_line 0 then
      (* do nothing on ls *)
      process_lines_into_tree lines (index+1) output
    else if Str.string_match outputline_dir next_line 0 then
      (* if we see a dir line, add a twig *)
      let new_node = Twig {data = (Str.matched_group 1 next_line, -1); children = []; parent = Some output} in
      let new_output = match output with
      | Twig t ->
        let () = t.children <- new_node :: t.children in
        output
      | _ ->
        raise (Syntax_error ("Adding child to leaf node @" ^ (string_of_int index)))
      in
      process_lines_into_tree lines (index+1) new_output
    else if Str.string_match outputline_file next_line 0 then
      (* if we see a file line, add a leaf *)
      let new_node = Leaf {data = (Str.matched_group 2 next_line, int_of_string (Str.matched_group 1 next_line)); parent = output} in
      let new_output = match output with 
      | Twig t ->
        let () = t.children <- new_node :: t.children in
        output
      | _ ->
        raise (Syntax_error ("Adding child to leaf node @" ^ (string_of_int index)))
      in 
      process_lines_into_tree lines (index+1) new_output
    else 
      raise (Syntax_error ("Non-matching input line: '" ^ next_line ^ "' @" ^ (string_of_int index)))  

  let rec sum_node_sizes (children: (string * int) tree list): int = 
    let sizes = List.map (fun (a: (string * int) tree): int ->
      match (get_node_size a) with
      | Some x ->
        x
      | None ->
        (* node has no size, so add size to it *)
        let i = add_size_to_node (a) in
        Option.get (get_node_size i)
    ) children in
    List.fold_left (+) 0 sizes
  
  and add_size_to_node (input: (string * int) tree): (string * int) tree = 
    match input with
    | Twig t ->
      (* if we're a twig, calculate size = sum of children and update*)
      let size = sum_node_sizes t.children in
      let () = t.data <- (fst t.data, size) in
      input
    | Leaf _ ->
      input
    | _ ->
      raise (Syntax_error ("Cannot add size to Empty tree node!"))
  
  let rec get_all_folder_sizes (input: (string * int) tree): int list = 
    match input with
    | Twig {data = (_, s); children = c; parent = _} ->
      [s] @ (List.fold_left (@) [] (List.map get_all_folder_sizes c))
    | _ ->
      []
  
  let list_min (l: int list): int = 
    let rec gather (l: int list) (current: int) =
      match l with
      | [] -> current
      | head::tail -> gather tail (min current head)
    in
    gather l max_int

  let main (input: string) = 
    let lines_of_input = Str.split (Str.regexp "\n") input in
    let file_tree = process_lines_into_tree lines_of_input 0 Empty in
    let tree_with_sizes = add_size_to_node file_tree in
    let () = print_tree tree_with_sizes in

    let sizes = get_all_folder_sizes tree_with_sizes in
    let output = (List.fold_left (+) 0 (List.filter (fun a -> a <= 100000) sizes),
                  list_min (List.filter (fun a -> a >= 572957) sizes)) in
    print_int (snd output)
end