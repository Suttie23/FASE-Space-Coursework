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

   -- Update Height of Orbit
   procedure Update_Height(S : in out Station_Record; New_Height : in Integer)
   is
   begin
      if (New_Height >= 820000 and New_Height <= 920000) and SealedInvariant then
         S.Altitude := New_Height;
      else
         Put_Line ("");
         Put_Line ("WARNING: UNSAFE ORBITAL ADJUSTMENT DETECTED!");
         delay 0.8;
         Put_Line ("WARNING: DISREGARDING ORBITAL ADJUSTMENT");
         delay 0.8;
         Put_Line ("WARNING: PLEASE SET A HEIGHT BETWEEN 820,000ft AND 920,000ft");
         delay 0.8;
         Put_Line ("");
      end if;
   end Update_Height;

   -- Procedure to add a module to the stack
   procedure Add_Module(S : in out Station_Record; New_Module : in Module) is
   begin
      -- Shift all modules to the right to create space for the new module
      for I in reverse 2..S.Modules'Last loop
         S.Modules(I) := S.Modules(I-1);
      end loop;
      -- Insert the new module at the top of the stack
      S.Modules(1) := New_Module;
      S.Top_Module_Index := S.Top_Module_Index + 1;
   end Add_Module;

   -- Procedure to remove the top module from the stack
   procedure Remove_Top_Module(S : in out Station_Record) is
   begin

   -- Remove the top module
   for i in reverse S.Modules'Range loop
      if S.Modules(i) /= Empty then
            S.Modules(i) := Empty;
            S.Top_Module_Index := S.Top_Module_Index - 1;
            exit;
         elsif S.Top_Module_Index = 1 and S.Modules(2) = Empty and S.Modules(3) = Empty then
            Put_Line ("WARNING: CANNOT REMOVE THE ONLY REMAINING STATION MODULE");
            exit;
      end if;
   end loop;
end Remove_Top_Module;

end Station;
