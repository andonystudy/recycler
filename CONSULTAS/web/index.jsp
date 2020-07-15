<%-- 
    Document   : index
    Created on : 15/07/2020, 10:43:31 AM
    Author     : Berrocal-PC
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>INSTITUTO IDAT</title>
        <link rel="stylesheet" href="https://bootswatch.com/4/litera/bootstrap.min.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
    </head>
    <body>
    <center>
        <h1>SELECIONAR DATOS</h1>
        <form action="index.jsp" method="post">
            SELECCIONAR EL CODIGO DEL CLIENTE: 
            <div class="card m-4">
                <div class="card-body pb-0">
                    <div class="">
                        <div class="form-group col-4">
                            <SELECT NAME="combo" CLASS="parameter_Select form-control">
                                <%
                                    Conexion cn = new Conexion();
                                    Connection con;
                                    PreparedStatement ps;
                                    ResultSet rs;
                                    String sql = "SELECT idcliente,nombrecompania FROM clientes";
                                    try {
                                        con = cn.Conexion();
                                        ps = con.prepareStatement(sql);
                                        rs = ps.executeQuery();
                                        while (rs.next()) {
                                            out.println("<OPTION VALUE=\"" + rs.getString(1) + "\">" + rs.getString(1) + "</OPTION>");
                                        }
                                    } catch (Exception e) {
                                    }
                                %>
                            </SELECT>
                        </div>
                        <div class="form-group col-2 m-0">
                            <input type="submit" class="btn btn-info" value="BUSCAR" name="vista" /><br><br>
                        </div>
                    </div>
                </div>
            </div>
        </form>


        <div class="container-fluid mb-5" style="padding-right: 50px; padding-left: 50px" >
            <table border="1" width="100%" align="center" class="table table-striped">
                <tr>  
                <thead class="thead-dark"> <th colspan="8"> PEDIDOS</th></thead>
                </tr>   
                <thead class="bg-success text-white">    
                    <tr class="text-center">
                        <th>IDPEDIDO</th>   
                        <th>FECHA PEDIDO</th>
                        <th>NOMBRE PRODUCTO</th>
                        <th>PRECIO UNIDAD</th>
                        <th>CANTIDAD</th>
                        <th>SUBTOTAL</th>
                        <th>IGV</th>
                        <th>NETO</th>
                    </tr>
                </thead>
                <%
                    double pagar = 0.0;
                    if (request.getParameter("vista") != null) {
                        String cliente = request.getParameter("combo");
                        String nombre = "";
                        String sql2 = "SELECT nombrecompania FROM clientes "
                                + "where idcliente='" + cliente + "'";
                        try {
                            con = cn.Conexion();
                            ps = con.prepareStatement(sql2);
                            rs = ps.executeQuery();
                            if (rs.next()) {
                                nombre = rs.getString(1);
                            }
                        } catch (Exception e) {
                        }


                %>
                IDCLIENTE:<%=cliente%><br><br>
                NOMBRE COMPANIA: <%=nombre%><br><br>   

                <%
                    String sql3 = "SELECT pe.idpedido, pe.fechapedido, "
                            + "pr.nombreproducto, de.preciounidad, de.cantidad, "
                            + "de.preciounidad*de.cantidad 'SUBTOTAL', "
                            + "(de.preciounidad*de.cantidad)*0.18 'IGV', "
                            + "(de.preciounidad*de.cantidad)*1.18 'NETO' "
                            + "FROM clientes cl inner join pedidos pe "
                            + "on cl.idcliente=pe.idcliente inner join "
                            + "detallesdepedidos de on pe.idpedido=de.idpedido "
                            + "inner join productos pr on de.idproducto=pr.idproducto "
                            + "where cl.idcliente='" + cliente + "'";

                    try {
                        con = cn.Conexion();
                        ps = con.prepareStatement(sql3);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                %>          
                <tr class="text-center">
                    <td><%= rs.getString(1)%></td>
                    <td><%= rs.getString(2)%></td>
                    <td><%= rs.getString(3)%></td>
                    <td><%= rs.getString(4)%></td>
                    <td><%= rs.getString(5)%></td>
                    <td><%= rs.getString(6)%></td>
                    <td><%= rs.getString(7)%></td>
                    <td><%= rs.getString(8)%></td>                    
                </tr>
                <%
                                pagar = pagar + Double.parseDouble(rs.getString(8));
                            }
                        } catch (Exception e) {
                        }
                    }
                %>  
            </table>
            TOTAL A PAGAR ES= <%=pagar%>



        </div>
    </table>
</div>
</center>
