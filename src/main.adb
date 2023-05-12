with Station; use Station;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   Str: String (1..2);
   Last: Natural;

   task ControlPanel;

   procedure DashboardControls is
   begin

      Put_Line("");
      Put_Line("------------------------------");
      Put_Line("Napier Space Station Status");
      Put_Line("------------------------------");
      Put_Line("Interior Airlock: " & S.Door1'Image);
      Put_Line("Exterior Airlock: " & S.Door2'Image);
      Put_Line("Altitude: " & S.Altitude'Image & "ft (820,000ft Min, 920,000ft Max)");
         Put_Line("");
      Put_Line("------------------------------");
      Put_Line("Station Modules");
      Put_Line("------------------------------");
      Put_Line("Module: " & S.Modules(1)'Image);
      Put_Line("Moudle: " & S.Modules(2)'Image);
      Put_Line("Module: " & S.Modules(3)'Image);
         Put_Line("");
      Put_Line("Index of Top Module:" & S.Top_Module_Index'Image);
         Put_Line("");
      Put_Line("------------------------------");
      Put_Line("Crew Status");
      Put_Line("------------------------------");
      Put_Line("Name: " & S.Crew(1).Name'Image & " // Status: " & S.Crew(1).Status'Image & " // Location: " & S.Crew(1).Location'Image);
      Put_Line("Name: " & S.Crew(2).Name'Image & " // Status: " & S.Crew(2).Status'Image & " // Location: " & S.Crew(2).Location'Image);
      Put_Line("Name: " & S.Crew(3).Name'Image & " // Status: " & S.Crew(3).Status'Image & " // Location: " & S.Crew(3).Location'Image);
         Put_Line("");
      Put_Line("------------------------------");
      Put_Line("Napier Space Station Control Panel");
      Put_Line("------------------------------");
      Put_Line("(a) - Open Interior Door");
      Put_Line("(b) - Open Exterior Door");
      Put_Line("(c) - Seal Airlock");
      Put_Line("(d) - Adjust Orbit");
      Put_Line("(e) - Add Module");
      Put_Line("(f) - Remove Module");
      Put_Line("(g) - Attempt Spacewalk");
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
         when 'd' =>
            Put_Line("Adjust Altitude by: ");
            Put_Line("(1) + 10000ft");
            Put_Line("(2) + 25000ft");
            Put_Line("(3) - 10000ft");
            Put_Line("(4) - 25000ft");
            Get_Line(Str, Last);
               case Str(1) is
               when '1' => Update_Height(S, S.Altitude + 10000);
               when '2' => Update_Height(S, S.Altitude + 25000);
               when '3' => Update_Height(S, S.Altitude - 10000);
               when '4' => Update_Height(S, S.Altitude - 25000);
               when others => exit;
            end case;
         when 'e' =>
            Put_Line("Select a Module to Add: ");
            Put_Line("(1) Research Bay");
            Put_Line("(2) Crew Quarters");
            Put_Line("(3) Communications Array");
               Get_Line(Str, Last);
               case Str(1) is
               when '1' => Add_Module(S, ResearchBay);
               when '2' => Add_Module(S, CrewQuarters);
               when '3' => Add_Module(S, CommunicationsArray);
               when others => exit;
            end case;
         when 'f' => Remove_Top_Module(S);
            when 'g' => Attempt_Spacewalk(S);
         when others => exit;
         end case;
      end loop;
      delay 0.1;
   end ControlPanel;

begin
  null;
end Main;
