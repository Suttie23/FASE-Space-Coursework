with Station; use Station;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   S : Station_Record;

begin
   S.Door1 := Closed;
   S.Door2 := Closed;

   Open_Door(S, 2);
   Put_Line ("Door 1 is:" & S.Door1'Image);
   Put_Line ("Door 2 is:" & S.Door2'Image);

   Open_Door(S, 1);
   Put_Line ("Door 1 is: " & S.Door1'Image);
   Put_Line ("Door 2 is: " & S.Door2'Image);

   Seal_Airlock(S);
   Put_Line ("Door 1 is: " & S.Door1'Image);
   Put_Line ("Door 2 is: " & S.Door2'Image);

end Main;
