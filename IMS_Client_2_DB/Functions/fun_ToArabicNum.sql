
Create  FUNCTION dbo.fun_ToArabicNum (@num varchar(10))
  RETURNS nvarchar(20)
AS
BEGIN
declare @Output nvarchar(20);
declare @Result nvarchar(20);
declare @Ones Nvarchar(1);
declare @len int;
declare @index int;

set @len = len(@num);
set @index = 1;
SET @OUTPUT = N'';

  while(@len >  0)
  begin
set @Ones = SUBSTRING(@num, @index, 1)

set @index = @index + 1;
set @len = @len - 1;

if @Ones = '1'
begin
set @Result = N'١'
end
else if @Ones = '2'
begin
set @Result = N'٢'
end
else if @Ones = '3'
begin
set @Result = N'٣'
end
else if @Ones = '4'
begin
set @Result = N'٤'
end
else if @Ones = '5'
begin
set @Result = N'٥'
end
else if @Ones = '6'
begin
set @Result = N'٦'
end
else if @Ones = '7'
begin
set @Result = N'٧'
end
else if @Ones = '8'
begin
set @Result = N'٨'
end
else if @Ones = '9'
begin
set @Result = N'٩'
end
else if @Ones = '0'
begin
set @Result = N'٠'
end
else if @Ones = '.'
begin
set @Result = N','
end

set @Output = CAST(@Output AS NVARCHAR(10)) + CAST(@Result AS NVARCHAR(10));
 end

return @Output;

end
GO