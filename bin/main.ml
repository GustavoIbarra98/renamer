let spaces_transform f =
  String.trim f
  |> String.split_on_char ' '
  |> String.concat "_"

let print_help () =
  print_endline "Usage: renamer [OPTIONS] [DIRECTORY]";
  print_endline "";
  print_endline "Options:";
  print_endline "  --dry-run          Preview renames without applying them";
  print_endline "  --lowercase        Convert filenames to lowercase";
  print_endline "  --prefix <text>    Add a prefix to filenames";
  print_endline "  --remove-spaces    Delete all spaces from filenames";
  print_endline "  --replace-plus     Replace + signs with underscores";
  print_endline "  --help             Show this help message";
  print_endline "";
  print_endline "Examples:";
  print_endline "  renamer .";
  print_endline "  renamer --dry-run .";
  print_endline "  renamer --lowercase .";
  print_endline "  renamer --prefix draft_ .";
  print_endline "  renamer --remove-spaces .";
  print_endline "  renamer --replace-plus ."

let find_prefix args =
  let rec aux = function
    | "--prefix" :: value :: _ -> Some value
    | _ :: rest -> aux rest
    | [] -> None
  in
  aux args

let get_transform args =
  if List.mem "--lowercase" args then
    Renamer.lowercase_transform
  else if List.mem "--remove-spaces" args then
    Renamer.remove_spaces
  else if List.mem "--replace-plus" args then
    Renamer.replace_plus
  else
    match find_prefix args with
    | Some prefix -> Renamer.prefix_transform prefix
    | None -> spaces_transform

let clean_args args =
  let prefix = find_prefix args in
  List.filter (fun a ->
    a <> "--dry-run" &&
    a <> "--lowercase" &&
    a <> "--prefix" &&
    a <> "--remove-spaces" &&
    a <> "--replace-plus" &&
    (match prefix with Some p -> a <> p | None -> true)
  ) args

let () =
  let args = Array.to_list Sys.argv |> List.tl in
  if List.mem "--help" args then print_help ()
  else begin
    let dry_run = List.mem "--dry-run" args in
    let transform = get_transform args in
    let dir_args = clean_args args in
    let dir = if dir_args = [] then "." else List.hd dir_args in
    let preview = Renamer.rename_preview dir transform in
    if preview = [] then
      print_endline "No files to rename."
    else begin
      print_endline "Preview:";
      List.iter (fun (original, new_name) ->
        Printf.printf "  %s -> %s\n" original new_name) preview;
      if dry_run then
        print_endline "Dry run — no files were renamed."
      else begin
        print_endline "Rename? (y/n)";
        let answer = read_line () in
        if answer = "y" then
          Renamer.rename_files dir transform
        else
          print_endline "Cancelled."
      end
    end
  end
