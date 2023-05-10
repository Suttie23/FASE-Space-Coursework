with Ada.Text_IO; use Ada.Text_IO;

package body Station with SPARK_mode
is


   -- Open Airlock Door
procedure Open_Door (S : in out Station_Record; Airlock_Number : Integer) is
   begin
      if Airlock_Number = 1 and SealedInvariant then
         S.Door1 := Open;
         S.Door2 := Closed;
         Put_Line ("Opening Interior Door...");
         delay 0.5;
         Put_Line ("Door 1 is:" & S.Door1'Image);
         Put_Line ("Door 2 is:" & S.Door2'Image);
         Put_Line ("");

      elsif Airlock_Number = 2 and SealedInvariant then
         S.Door2 := Open;
         S.Door1 := Closed;

         Put_Line ("Opening Exterior Door...");
         delay 0.5;
         Put_Line ("Door 1 is: " & S.Door1'Image);
         Put_Line ("Door 2 is: " & S.Door2'Image);
         Put_Line ("");
      else
         S.Door2 := Closed;
         S.Door1 := Closed;
         Put_Line ("");
         Put_Line ("WARNING: DEPRESSURISATION RISK - ENSURING BOTH DOORS ARE CLOSED");
         Put_Line ("");
      end if;
   end Open_Door;

   -- Seal Airlock
   procedure Seal_Airlock (S : in out Station_Record) is
   begin
         if S.Door1 = Open then
         S.Door1 := Closed;
      elsif S.Door2 = Open then
         S.Door2 := Closed;
      end if;

   Put_Line ("Sealing Airlock...");
   delay 0.5;
   Put_Line ("Door 1 is: " & S.Door1'Image);
   Put_Line ("Door 2 is: " & S.Door2'Image);
   Put_Line ("");

   end Seal_Airlock;

   procedure Update_Height(S : in out Station_Record; New_Height : in Integer)
   is
   begin
      if (New_Height >= 820000 and New_Height <= 920000) and SealedInvariant then
         S.Altitude := New_Height;
      else
         Put_Line ("");
         Put_Line ("WARNING: UNSAFE ORBITAL ADJUSTMENT DETECTED!");
         Put_Line ("");
      end if;
   end Update_Height;

end Station;
