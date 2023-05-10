with Station; use Station;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   Str: String (1..2);
   Last: Natural;
   S : Station_Record;

   task ControlPanel;

   procedure DashboardControls is
   begin
      Put_Line("------------------------------");
      Put_Line("Napier Space Station Dashboard Dashboard");
      Put_Line("------------------------------");
      Put_Line("Interior Airlock: " & S.Door1'Image);
      Put_Line("Exterior Airlock: " & S.Door2'Image);
      Put_Line("Altitude: dummyvalue" & "ft (820,000ft Min, 920,000ft Max)");
         Put_Line("");
         Put_Line("");
      Put_Line("------------------------------");
      Put_Line("Napier Space Station Control Panel");
      Put_Line("------------------------------");
      Put_Line("(a) - Open Interior Door");
      Put_Line("(b) - Open Exterior Door");
      Put_Line("(c) - Seal Airlock");
      Put_Line("");
      Put_Line("Enter command:");
   end DashboardControls;

   task body ControlPanel is
   begin
      loop
         DashboardControls;
         Get_Line(Str, Last);
         case (Str(1)) is
         when 'a' => Open_Door(S, 1);
         when 'b' => Open_Door(S, 2);
         when 'c' => Seal_Airlock(S);
         when others => exit;
         end case;
      end loop;
      delay 0.1;
   end ControlPanel;

begin
  null;
end Main;
