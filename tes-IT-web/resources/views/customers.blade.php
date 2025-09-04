<!DOCTYPE html>
<html>

<head>
    <title>Data Tirtakencana</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        h2 {
            margin-top: 40px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
        }

        th,
        td {
            border: 1px solid #aaa;
            padding: 6px 10px;
            text-align: left;
        }

        th {
            background: #007BFF;
            color: white;
        }
    </style>
</head>

<body>
    <h1>Data Tirtakencana</h1>

    <!-- Customer -->
    <h2>Customer</h2>
    <table>
        <tr>
            <th>CustID</th>
            <th>Nama</th>
            <th>Alamat</th>
            <th>Telepon</th>
        </tr>
        @foreach ($customers as $c)
            <tr>
                <td>{{ $c->CustID }}</td>
                <td>{{ $c->Name }}</td>
                <td>{{ $c->Address }}</td>
                <td>{{ $c->PhoneNo }}</td>
            </tr>
        @endforeach
    </table>

    <!-- CustomerTTH -->
    <h2>CustomerTTH (Header Transaksi)</h2>
    <table>
        <tr>
            <th>TTHNo</th>
            <th>SalesID</th>
            <th>TTOTTPNo</th>
            <th>CustID</th>
            <th>DocDate</th>
            <th>Received</th>
            <th>ReceivedDate</th>
            <th>Reason</th>
        </tr>
        @foreach ($tth as $t)
            <tr>
                <td>{{ $t->TTHNo }}</td>
                <td>{{ $t->SalesID }}</td>
                <td>{{ $t->TTOTTPNo }}</td>
                <td>{{ $t->CustID }}</td>
                <td>{{ $t->DocDate }}</td>
                <td>{{ $t->Received }}</td>
                <td>{{ $t->ReceivedDate }}</td>
                <td>{{ $t->FailedReason }}</td>
            </tr>
        @endforeach
    </table>

    <!-- CustomerTTHDetail -->
    <h2>CustomerTTHDetail (Detail Hadiah)</h2>
    <table>
        <tr>
            <th>TTHNo</th>
            <th>TTOTTPNo</th>
            <th>Jenis</th>
            <th>Qty</th>
            <th>Unit</th>
        </tr>
        @foreach ($tthDetail as $d)
            <tr>
                <td>{{ $d->TTHNo }}</td>
                <td>{{ $d->TTOTTPNo }}</td>
                <td>{{ $d->Jenis }}</td>
                <td>{{ $d->Qty }}</td>
                <td>{{ $d->Unit }}</td>
            </tr>
        @endforeach
    </table>

    <!-- MobileConfig -->
    <h2>MobileConfig</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>BranchCode</th>
            <th>Name</th>
            <th>Description</th>
            <th>Value</th>
        </tr>
        @foreach ($mobileConfig as $m)
            <tr>
                <td>{{ $m->ID }}</td>
                <td>{{ $m->BranchCode }}</td>
                <td>{{ $m->Name }}</td>
                <td>{{ $m->Description }}</td>
                <td>{{ $m->Value }}</td>
            </tr>
        @endforeach
    </table>

</body>

</html>
