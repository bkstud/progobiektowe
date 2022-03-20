program bubblesort;

type
  IntegerArray = array of Integer;

function genarray(size: Integer; max_val: Integer):IntegerArray;
var
  arr: IntegerArray;
  i: integer;
begin
  setLength(arr, size);
  randomize();
  for i := 0 to size - 1 do
  begin
    // Random returns a random number larger or equal to 0 and strictly less than L. 
    arr[i] := random(max_val + 1);
  end; 
  genarray := arr;
end;

procedure sort(arr: IntegerArray);
var 
    i: integer;
    j: integer;
    temp: integer;
    size: integer;
begin
  size := Length(arr);
  
  for i := 0 to size - 1 do
  begin
    for j := i + 1 to size - 1 do
    begin
      if arr[j] > arr[i] then
      begin
        temp := arr[i];
        arr[i] := arr[j];
        arr[j] := temp;
      end;
    end;
  end;	  

end;

procedure printarr(arr: IntegerArray);
var
  i: integer;
begin
  for i := 0 to Length(arr) - 1 do
  begin
    write(arr[i], ', ');
  end;
end;

var
  arr: IntegerArray;
  i: integer;
begin
   arr := genarray(50, 100);
   writeln('Before sorting:');
   printarr(arr);
   writeln(#13#10'After sorting:');
   sort(arr);
   printarr(arr);
   writeln();
end.
