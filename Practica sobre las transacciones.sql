delimiter //

create procedure realizar_pago_con_stock (
    in t_codigo_cliente int,
    in t_id_transaccion varchar(50),
    in t_importe decimal (15,2),
    in t_codigo_producto varchar(20), 
    in t_cantidad int,
    in t_forma_pago varchar(50)
)

begin
    declare stock_actual int;

    declare exit handler for sqlexception
    begin
        rollback;
		select "error en la transacción";
    end;
    
    start transaction;
    
    select cantidad_en_stock into stock_actual 
    from producto 
    where codigo_producto = t_codigo_producto 
    for update;
    
    if stock_actual < t_cantidad then 
        rollback;
        select "stock insuficiente";
    
    else 
        insert into pago (codigo_cliente, forma_pago, id_transaccion, fecha_pago, total) 
        values (t_codigo_cliente, t_forma_pago, t_id_transaccion, curdate(), t_importe);
        
        update producto 
        set cantidad_en_stock = cantidad_en_stock - t_cantidad 
        where codigo_producto = t_codigo_producto;
        
        commit;
    end if;

end //

delimiter ;

drop procedure realizar_pago_con_stock;

call realizar_pago_con_stock(1, 'pago1', 50.00, '11679', 10, 'tarjeta');
call realizar_pago_con_stock(1, 'pago2', 50.00, '11679', 1000, 'tarjeta');
call realizar_pago_con_stock(1, 'pago3', 50.00, 'no_existe', 5, 'tarjeta');
call realizar_pago_con_stock(9999, 'pago4', 50.00, '11679', 5, 'tarjeta');
call realizar_pago_con_stock(1, 'pago5', 50.00, '11679', 5, 'tarjeta');
call realizar_pago_con_stock(1, 'pago5', 60.00, '11679', 5, 'efectivo');
call realizar_pago_con_stock(1, 'pago6', 50.00, '11679', 15, 'transferencia');