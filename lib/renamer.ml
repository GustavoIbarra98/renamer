let lowercase_transform f =
  String.lowercase_ascii f

let prefix_transform prefix f =
  prefix ^ f



let remove_spaces f =
    String.trim f
    |> String.to_seq
    |> Seq.filter (fun c -> c <> ' ')
    |> String.of_seq
  
let replace_plus f =
    String.to_seq f
    |> Seq.map (fun c -> if c = '+' then '_' else c)
    |> String.of_seq
    
let list_files dir =
  Sys.readdir dir
  |> Array.to_list
  |> List.filter (fun f ->
    let path = Filename.concat dir f in
    not (Sys.is_directory path))


 let rename_preview dir transform =
      list_files dir
      |> List.map (fun f ->
        let new_name = transform f in
        (f, new_name))
      |> List.filter (fun (original, new_name) -> original <> new_name)

      let rename_files dir transform =
        let preview = rename_preview dir transform in
        List.iter (fun (original, new_name) ->
          let old_path = Filename.concat dir original in
          let new_path = Filename.concat dir new_name in
          Sys.rename old_path new_path;
          Printf.printf "Renamed: %s -> %s\n" original new_name) preview