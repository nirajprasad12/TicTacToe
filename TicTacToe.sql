set serveroutput on;

--create table if it does not exist
declare
var_tab_exists int;
begin
    select count(table_name) into var_tab_exists from user_tables where table_name = 'TICTAC';
    if var_tab_exists = 0 then
        execute immediate ('create table ticTac( 
        indexTerm number,
        P varchar(3), 
        Q varchar(3), 
        R varchar(3),
        rec_upd_gamer_id varchar(3),
        rec_upd_ts timestamp default systimestamp
        )');
    end if;
end;
/


-- Show Grid
create or replace procedure show_grid as 
begin  
  for i in (select * from ticTac order by indexTerm) loop 
    dbms_output.put_line('  ' || i."P" || ' ' || i."Q" || ' ' || i."R"); 
  end loop;
  dbms_output.put_line(' '); 
end; 
/

-- Start Game
create or replace procedure start_game 
is 
begin 
  delete from ticTac; 
  insert into ticTac (indexTerm, P, Q, R) values (1,'_','_','_'); 
  insert into ticTac (indexTerm, P, Q, R) values (2,'_','_','_');
  insert into ticTac (indexTerm, P, Q, R) values (3,'_','_','_');
  commit;
  dbms_output.put_line('Run nextTurn() stored procedure to play'); 
end;
/

-- For returning a character for integer input
create or replace function numberToFieldName(numberEntered in number) 
return varchar 
is 
begin 
  if numberEntered = 1 then return 'P'; 
  elsif numberEntered = 2 then return 'Q';  
  elsif numberEntered = 3 then return 'R'; 
  else return '_';
  end if; 
end; 
/

--for winner
create or replace procedure winner(gamer varchar) as
begin
    dbms_output.put_line('Gamer '|| gamer || ' Wins!');
    show_grid();
    dbms_output.put_line('Game will now reset');
    start_game();
end;
/

create or replace procedure checkDiagonals(gamer ticTac.P%type) as
diag1_1 ticTac.P%type;
diag1_2 ticTac.P%type;
diag1_3 ticTac.P%type;
diag2_1 ticTac.P%type;
diag2_2 ticTac.P%type;
diag2_3 ticTac.P%type;
count_diag number;
begin
    count_diag := 0;
    
    --for 1st Diagonal
    select P into diag1_1 from ticTac where indexTerm = 1;
    select Q into diag1_2 from ticTac where indexTerm = 2;
    select R into diag1_3 from ticTac where indexTerm = 3;
    
    if diag1_1 = gamer and diag1_2 = gamer and diag1_3 = gamer then
        count_diag := 1;
    end if;
    
    --for 2nd Diagonal
    select P into diag2_1 from ticTac where indexTerm = 3;
    select Q into diag2_2 from ticTac where indexTerm = 2;
    select R into diag2_3 from ticTac where indexTerm = 1;
    
    if diag2_1 = gamer and diag2_2 = gamer and diag2_3 = gamer then
        count_diag := 1;
    end if;
    if count_diag = 1 then
        winner(gamer);
    end if;
end;
/

create or replace procedure checkRows(gamer ticTac.P%type) as
v1 ticTac.P%type;
v2 ticTac.P%type;
v3 ticTac.P%type;
v4 ticTac.P%type;
v5 ticTac.P%type;
v6 ticTac.P%type;
v7 ticTac.P%type;
v8 ticTac.P%type;
v9 ticTac.P%type;
count_row number;
begin
    count_row := 0;
    
    --for 1st Row
    select P into v1 from ticTac where indexTerm = 1;
    select Q into v2 from ticTac where indexTerm = 1;
    select R into v3 from ticTac where indexTerm = 1;
    
    if v1 = gamer and v2 = gamer and v3 = gamer then
        count_row := 1;
    end if;
    
    --for 2nd Row
    select P into v4 from ticTac where indexTerm = 2;
    select Q into v5 from ticTac where indexTerm = 2;
    select R into v6 from ticTac where indexTerm = 2;
    
    if v4 = gamer and v5 = gamer and v6 = gamer then
        count_row := 1;
    end if;
    
    --for 3rd Row
    select P into v7 from ticTac where indexTerm = 3;
    select Q into v8 from ticTac where indexTerm = 3;
    select R into v9 from ticTac where indexTerm = 3;
    
    if v7 = gamer and v8 = gamer and v9 = gamer then
        count_row := 1;
    end if;
    
    if count_row = 1 then
        winner(gamer);
    end if;
end;
/

create or replace procedure checkColumns(gamer ticTac.P%type) as
v1 ticTac.P%type;
v2 ticTac.P%type;
v3 ticTac.P%type;
v4 ticTac.P%type;
v5 ticTac.P%type;
v6 ticTac.P%type;
v7 ticTac.P%type;
v8 ticTac.P%type;
v9 ticTac.P%type;
count_col number;
begin
    count_col := 0;
    
    --for 1st Row
    select P into v1 from ticTac where indexTerm = 1;
    select P into v2 from ticTac where indexTerm = 2;
    select P into v3 from ticTac where indexTerm = 3;
    
    if v1 = gamer and v2 = gamer and v3 = gamer then
        count_col := 1;
    end if;
    
    --for 2nd Row
    select Q into v4 from ticTac where indexTerm = 1;
    select Q into v5 from ticTac where indexTerm = 2;
    select Q into v6 from ticTac where indexTerm = 3;
    
    if v4 = gamer and v5 = gamer and v6 = gamer then
        count_col := 1;
    end if;
    
    --for 3rd Row
    select R into v7 from ticTac where indexTerm = 1;
    select R into v8 from ticTac where indexTerm = 2;
    select R into v9 from ticTac where indexTerm = 3;
    
    if v7 = gamer and v8 = gamer and v9 = gamer then
        count_col := 1;
    end if;
    
    if count_col = 1 then
        winner(gamer);
    end if;
end;
/

--check Results
create or replace procedure checkResults(gamer ticTac.P%type) as
v_cnt number;
begin
    v_cnt := 0;
    select count(*) into v_cnt from (select p, q, r from ticTac where p = '_' or q = '_' or r = '_');
    if v_cnt > 0 then
        checkDiagonals(gamer);
        checkRows(gamer);
        checkColumns(gamer);
    else
        dbms_output.put_line('Game ends in a draw!');
        dbms_output.put_line('Resetting game...');
        start_game();
    end if;     
end;
/

create or replace procedure nextTurn(in_gamer ticTac.P%type, in_getRowID number, in_getColID number) is
v_gamer ticTac.P%type;
v_fieldVal ticTac.P%type;
v_getColID varchar(3);
e_userAlreadyPlayed exception;
begin
    
    select rec_upd_gamer_id into v_gamer from ticTac where rec_upd_ts = (select max(rec_upd_ts) from ticTac);
    
    if v_gamer = in_gamer then
        raise e_userAlreadyPlayed;
    else
        dbms_output.put_line('Turn played');
        select numberToFieldName(in_getColID) into v_getColID from dual; -- get column
        execute immediate ('select ' || v_getColID || ' from ticTac where indexTerm = ' || in_getRowID) into v_fieldVal; --get original record
    
        if upper(in_gamer) = 'X' or upper(in_gamer) = 'O' then
    
            if v_fieldVal = '_' then 
                execute immediate ('update ticTac set ' || v_getColID || '=upper('''|| in_gamer ||'''), rec_upd_gamer_id = upper('''|| in_gamer ||'''), rec_upd_ts = systimestamp  WHERE indexTerm = '|| in_getRowID);
                commit;
            else 
                dbms_output.put_line('This square has already been filled'); 
            end if; 
        else
            dbms_output.put_line('Wrong gamer entered, please enter either X or O only');
        end if;
        
        show_grid();

        checkResults(upper(in_gamer));
    end if;
    exception
    when e_userAlreadyPlayed then
    dbms_output.put_line('You have already played!! Please give a chance to the other gamer');
end; 
/

--test case for draw
exec start_game();
exec nextTurn('X', 1, 1);
exec nextTurn('O', 3, 2);
exec nextTurn('X', 2, 2);
exec nextTurn('O', 3, 3);
exec nextTurn('X', 3, 1);
exec nextTurn('O', 2, 1);
exec nextTurn('X', 1, 2);
exec nextTurn('O', 1, 3);
exec nextTurn('X', 2, 3);

--test case for X wins in diagonal
exec start_game();
exec nextTurn('X', 1, 1);
exec nextTurn('O', 3, 2);
exec nextTurn('X', 2, 2);
exec nextTurn('O', 3, 1);
exec nextTurn('X', 3, 3);

--test case for O wins in row
exec start_game();
exec nextTurn('X', 1, 1);
exec nextTurn('O', 3, 2);
exec nextTurn('X', 2, 2);
exec nextTurn('O', 3, 1);
exec nextTurn('X', 2, 1);
exec nextTurn('O', 3, 3);

--test case for X wins in column
exec start_game();
exec nextTurn('X', 1, 1);
exec nextTurn('O', 3, 2);
exec nextTurn('X', 2, 1);
exec nextTurn('O', 3, 3);
exec nextTurn('X', 3, 1);

--test case for wrong character entered
exec start_game();
exec nextTurn('X', 1, 1);
exec nextTurn('O', 3, 2);
exec nextTurn('X', 2, 1);
exec nextTurn('O', 3, 3);
exec nextTurn('C', 3, 1);

--test case to show handling of lowercase 'x' or 'o' and starting with gamer O
exec start_game();
exec nextTurn('o', 1, 1);
exec nextTurn('x', 3, 2);
exec nextTurn('o', 2, 1);
exec nextTurn('x', 3, 3);
exec nextTurn('o', 3, 1);

--test case for a gamer playing two turns at once handling
exec start_game();
exec nextTurn('X', 1, 1);
exec nextTurn('O', 3, 2);
exec nextTurn('X', 2, 1);
exec nextTurn('O', 3, 3);
exec nextTurn('O', 3, 1);

--test case for a square has already been filled
exec start_game();
exec nextTurn('X', 1, 1);
exec nextTurn('O', 3, 2);
exec nextTurn('X', 2, 1);
exec nextTurn('O', 3, 3);
exec nextTurn('X', 3, 3);
