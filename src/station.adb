with Ada.Text_IO; use Ada.Text_IO;

package body Station with SPARK_mode
is


   -- Open Airlock Door
procedure Open_Door (S : in out Station_Record; Airlock_Number : Integer) is
   begin

      Put_Line("");

      -- Open door 1 and ensure 2 is closed
      if Airlock_Number = 1 and SealedInvariant then
         S.Door1 := Open;
         S.Door2 := Closed;
         Put_Line ("Opening Interior Door...");
         delay 0.5;
         Put_Line ("Door 1 is:" & S.Door1'Image);
         Put_Line ("Door 2 is:" & S.Door2'Image);
         Put_Line ("");

         -- Open door 2 and ensure 1 is closed
      elsif Airlock_Number = 2 and SealedInvariant then
         S.Door2 := Open;
         S.Door1 := Closed;
         Put_Line ("Opening Exterior Door...");
         delay 0.5;
         Put_Line ("Door 1 is: " & S.Door1'Image);
         Put_Line ("Door 2 is: " & S.Door2'Image);
         Put_Line ("");

         -- Close Both doors in the event of an emergency (Should never trigger)
      elsif SealedInvariant = false then
         S.Door2 := Closed;
         S.Door1 := Closed;
         Put_Line ("");
         Put_Line ("WARNING: DEPRESSURISATION RISK - ENSURING BOTH DOORS ARE CLOSED");
         Put_Line ("");
      end if;
   end Open_Door;

   -- Seal Both Doors
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

      Put_Line("");

      -- Adjust orbital height if within acceptable parameters
      if (New_Height >= 820000 and New_Height <= 920000) and SealedInvariant then
         S.Altitude := New_Height;

         -- Warn of unsafe orbital adjustment and disregard command
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

      Put_Line("");

      -- Ensure that additional modules cannot be added
      if S.Top_Module_Index = 3 then
         delay 0.8;
         Put_Line ("");
         Put_Line("WARNING: ALL MODULES ARE OCCUPIED");
         delay 0.8;
         Put_Line("WARNING: PLEASE REMOVE A MODULE");
         delay 0.8;
         return;
      end if;

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

      Put_Line("");

      -- Ensure the final module cannot be removed
      if S.Top_Module_Index = 1 then
         Put_Line ("");
         Put_Line("WARNING: CANNOT REMOVE FINAL STATION MODULE");
         delay 0.8;
      return;
   end if;

   -- Check whether a crewmember is occupying the top level module
   for i in reverse S.Modules'Range loop
         if S.Modules(i) /= Empty then
            for k in S.Crew'Range loop
               -- If so, send them to the bottom level module
               if S.Crew(k).Location = S.Modules(i) then
                  S.Crew(k).Location := S.Modules(1);
                  Put_Line ("");
                  delay 0.8;
                  Put_Line(S.Modules(i)'Image & "Is occupied by " & S.Crew(k).Name'Image & ".");
                  delay 0.8;
                  Put_Line("Moving " & S.Crew(k).Name'Image & "to the " & S.Modules(1)'Image & " Module");
                  delay 0.8;
               end if;
            end loop;

            -- Remove the top module
            S.Modules(i) := Empty;
            S.Top_Module_Index := S.Top_Module_Index - 1;
            exit;
         elsif i = S.Modules'First and S.Top_Module_Index > 1 then
      -- Ensure top module is 1, as no further modules can be removed
      S.Top_Module_Index := 1;
      end if;
   end loop;
   end Remove_Top_Module;

   procedure Attempt_Spacewalk(S : in out Station_Record; CM : in Integer) is
      Top_CM : Integer := 0;
      Bottom_CM : Integer := 0;
   begin

      Put_Line("");
      -- Check whether the station is fully functional
      for i in S.Modules'Range loop
         if S.Modules(i) = Empty then
            Put_Line("SPACEWALK IS ONLY AVALIABLE WITH A FULLY FUNCTIONAL STATION!");
            return;
         end if;
      end loop;

      -- Check whether there is an ongoing spacewalk
      for i in S.Crew'Range loop
         if S.Crew(i).Status = Spacewalk then
            Put_Line("SPACEWALK IN PROGRESS, CANNOT PERFORM ANOTHER UNTIL CREWMAN HAS RETURNED");
            return;
         end if;
      end loop;

      -- Check whether selected Crewmember is avaliable
      if S.Crew(CM).Status /= Spacewalk then
         Put_Line(S.Crew(CM).Name'Image & " IS AVALIABLE FOR A SPACEWALK");
      else
         Put_Line(S.Crew(CM).Name'Image & " IS ALREADY ON A SPACEWALK");
         return;
      end if;

      -- Update the status of the selected Crewmembers to spacewalk
      S.Crew(CM).Status := Spacewalk;

      -- Get indicies of remaining two crew members
   for i in S.Crew'Range loop
      if i /= CM and S.Crew(i).Status /= Spacewalk then
         if Top_CM = 0 then
            Top_CM := i;
         else
            Bottom_CM := i;
            exit; -- Exit the loop once the bottom crew member has been identified
         end if;
      end if;
   end loop;

      -- Moving Crewmember (TOP) and setting their status
      S.Crew(Top_CM).Status := Monitoring;
      S.Crew(Top_CM).Location := S.Modules(3);

      -- Moving Crewmember (BOTTOM) and setting their status
      S.Crew(Bottom_CM).Status := Monitoring;
      S.Crew(Bottom_CM).Location := S.Modules(1);

      Put_Line(S.Crew(Top_CM).Name'Image & " Is moving to the " & S.Crew(Top_CM).Location'Image & " Module...");
      delay 0.8;
      delay 0.8;
      Put_Line(S.Crew(Bottom_CM).Name'Image & " Is moving to the " & S.Crew(Bottom_CM).Location'Image & " Module...");
      delay 0.8;
      delay 0.8;
      Put_Line("Crew standing by for spacewalk...");

      Open_Door(S, 1);
      delay 0.8;
      Put_Line(S.Crew(CM).Name'Image & " Is inside the airlock...");
      Put_Line("");
      delay 0.8;
      Open_Door(S, 2);
      delay 0.8;
      Put_Line(S.Crew(CM).Name'Image & " Has left the airlock...");
      Put_Line("");
      delay 0.8;
      Seal_Airlock(S);
      Put_Line(S.Crew(CM).Name'Image & " IS ON A SPACEWALK");

      S.Crew(CM).Location := Space;
      S.ActiveSpaceWalk := True;


   end Attempt_Spacewalk;

   -- Procedure to return a crewman from a spacewalk
   procedure Return_From_Spacewalk(S : in out Station_Record) is
   begin

      -- If not, do nothing
      if S.ActiveSpaceWalk = False then
         Put_Line("There are no crewmen on a spacewalk");
         delay 0.8;

         -- if there is, recall them to the station
      else
         for i in S.Crew'Range Loop
            if S.Crew(i).Status = Spacewalk then
               Put_Line(S.Crew(i).Name'Image & " Is Being Recalled...");
               delay 0.8;
               Open_Door(S, 2);
               delay 0.8;
               Put_Line(S.Crew(i).Name'Image & " Is inside the airlock...");
               Put_Line("");
               delay 0.8;
               Open_Door(S, 1);
               delay 0.8;
               Put_Line(S.Crew(i).Name'Image & " Has entered the station...");
               Put_Line("");
               delay 0.8;
               Seal_Airlock(S);
               Put_Line(S.Crew(i).Name'Image & " IS ON A SPACEWALK");

               S.Crew(i).Location := S.Modules(2);
               S.Crew(i).Status := Relaxing;
            else
               S.Crew(i).Status := Relaxing;
            end if;
         end Loop;
         S.ActiveSpaceWalk := False;
      end if;

   end Return_From_Spacewalk;



end Station;
