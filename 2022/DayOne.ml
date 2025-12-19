module DayOne = struct
  let main (input: string) =
    let lines_of_input: string list = Str.split (Str.regexp "\n\n") input in

    let groups_of_elf: string list list = List.map (
      fun a: string list -> (Str.split(Str.regexp "\n") a)) lines_of_input in

    let items_of_elf: int list list = List.map (
      fun elf: int list -> (List.map(
        fun item: int -> int_of_string item) elf)) groups_of_elf in

    let total_of_elf: int list = List.map(
      fun group: int -> List.fold_left (+) 0 group) items_of_elf in

    let first: int = List.fold_left max min_int total_of_elf in

    let second: int = List.fold_left max min_int (List.filter (
      fun a: bool -> a != first
    ) total_of_elf) in

    let third: int = List.fold_left max min_int (List.filter (
      fun a: bool -> a != first && a != second
    ) total_of_elf) in

    first + second + third
end