<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Threading.Tasks" %>
<%@ Import Namespace="System.Net" %>


<%@ Page Language="c#" AutoEventWireup="true" %>

<script runat="server">
    public string GetFromInstance(string url)
    {
        try
        {
            string instanceId = Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID");
            var cookieContainer = new CookieContainer();
            WebClient client = new WebClient();
            if (!string.IsNullOrEmpty(instanceId))
            {
                client.Headers.Add(HttpRequestHeader.Cookie, "ARRAffinity=" + instanceId);
            }
            client.Headers.Add("Content-Type", "text/json");
            string pagesource = client.DownloadString(url);
            return pagesource;
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
    public string GetIPAddress()
    {
        IPHostEntry ipHostInfo = Dns.GetHostEntry(Dns.GetHostName()); // `Dns.Resolve()` method is deprecated.
        string address = "";
        foreach (var ip in ipHostInfo.AddressList)
        {
            address = address + ip.ToString() + ", ";
        }

        return address;
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        base.OnLoad(e);
       
    }
    void btnSend_Click(Object sender, EventArgs e)
    {
        if (Page.IsPostBack)
        {
            var cookie = Request.Cookies.Get("ARRAffinity");
            ltlText.Text = cookie.Value;
        } 
    }
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <title>ASP.NET inline</title>
    <style type="text/css">
        table {
            border-collapse: collapse;
        }

        table, th, td {
            border: 1px solid black;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <asp:Literal runat="server" ID="ltlText"></asp:Literal>
        <table>
            <tr>
                <td>ARRAffinity: <%=Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID")%></td>
            </tr>
            <tr>
                <td>IP: <%=Request.ServerVariables["LOCAL_ADDR"]%></td>
            </tr>
            <tr>
                <td>IP: <%=HttpContext.Current.Request.UserHostAddress%></td>
            </tr>
            <tr>
                <td>IP: <%=GetIPAddress()%></td>
            </tr>
            <tr>
                <td><%=GetFromInstance("https://superapp-test-cd.azurewebsites.net/api/content/items?childrenDepth=0&path=/sitecore/content")%>.</td>
            </tr>
        </table>
        <asp:Button ID="btnSend" runat="server" Text="Send" OnClick="btnSend_Click" />
    </form>
</body>

</html>
