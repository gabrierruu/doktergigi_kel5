<?php
session_start();
if (!isset($_SESSION['username'])) {
    header("Location: index.html");
    exit;
}
$nama_user = $_SESSION['nama'];

// koneksi db
$koneksi = mysqli_connect("localhost", "root", "", "gigi") or die("Koneksi gagal");

// Simpan data pasien
if (isset($_POST['simpan'])) {
    $nama_pasien = trim($_POST['nama']);
    $alamat      = trim($_POST['alamat']);
    $telepon     = (int)$_POST['no_hp']; 
    $tgl         = (int)$_POST['tanggal'];
    $bln         = (int)$_POST['bulan'];
    $thn         = (int)$_POST['tahun'];
    $gender      = $_POST['gender'];

    // format tanggal lahir YYYY-MM-DD
    $tanggal_lahir = sprintf("%04d-%02d-%02d", $thn, $bln, $tgl);

    // prepared statement
    $stmt = mysqli_prepare($koneksi, 
        "INSERT INTO pasien (nama, no_hp, alamat, tanggal, gender) VALUES (?, ?, ?, ?, ?)"
    );

    if ($stmt) {
        mysqli_stmt_bind_param($stmt, "sisss", $nama_pasien, $telepon, $alamat, $tanggal_lahir, $gender);
        $exec = mysqli_stmt_execute($stmt);

        if ($exec) {
            echo "<script>alert('Data pasien berhasil disimpan'); window.location='patientlist.php';</script>";
        } else {
            echo "Error saat simpan: " . mysqli_error($koneksi);
        }

        mysqli_stmt_close($stmt);
    } else {
        echo "Gagal prepare statement: " . mysqli_error($koneksi);
    }
}
?>



<!doctype html>
<html lang="en">
  

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Database Dokter GIGI</title>
  <link rel="shortcut icon" type="image/png" href="./assets/images/logos/gigi-logo.png" />
  <!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

  <link rel="stylesheet" href="./assets/css/styles.min.css" />
  <style>
    body { background:#f8f9fa; }
    .container-form {
      max-width: 600px;
      margin: 40px auto;
      background: #fff;
      padding: 30px;
      border-radius: 20px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.08);
    }
    h2 { font-weight: bold; margin-bottom: 20px; }
    .form-control {
      border-radius: 30px;
      padding: 12px 20px;
      border: 1px solid #ccc;
    }
    .btn-submit {
      background-color: #FE7D7D;
      border: none;
      border-radius: 30px;
      padding: 12px;
      font-weight: bold;
      width: 100%;
      color: #fff;
      font-size: 16px;
    }
    .btn-submit:hover { background-color: #ff5c5c; }
    label { font-weight: bold; margin-top: 15px; }
  </style>
</head>

<body>
  <!-- Body Wrapper -->
  <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6"
    data-sidebartype="full" data-sidebar-position="fixed" data-header-position="fixed">

    <!-- Sidebar Start -->
    <aside class="left-sidebar">
      <!-- Sidebar scroll-->
      <div>
        <div class="brand-logo d-flex align-items-center justify-content-center">
          <a href="./dashboard.php" class="text-nowrap logo-img">
            <br>
            <img src="assets/images/logos/gigi.png" alt="" />
          </a>
          <div class="close-btn d-xl-none d-block sidebartoggler cursor-pointer" id="sidebarCollapse">
            <i class="ti ti-x fs-6"></i>
          </div>
        </div>
        <!-- Sidebar navigation-->
        <nav class="sidebar-nav scroll-sidebar" data-simplebar="">
          <ul id="sidebarnav">
            <li class="nav-small-cap">
              <iconify-icon icon="solar:menu-dots-linear" class="nav-small-cap-icon fs-4"></iconify-icon>
              <span class="hide-menu">Home</span>
            </li>
            <li class="sidebar-item">
              <a class="sidebar-link" href="./dashboard.php" aria-expanded="false">
                <i class="bi bi-grid-1x2-fill"></i>
                <span class="hide-menu">Dashboard</span>
              </a>
            </li>
            <li class="sidebar-item">
              <a class="sidebar-link justify-content-between has-arrow" href="javascript:void(0)" aria-expanded="false">
                <div class="d-flex align-items-center gap-3">
                  <i class="bi bi-calendar-check"></i>
                  <span class="hide-menu">Appointment</span>
                </div>
              </a>
              <ul aria-expanded="false" class="collapse first-level">
                <li class="sidebar-item">
                  <a class="sidebar-link justify-content-between" href="#">
                    <div class="d-flex align-items-center gap-3">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">All Appointment</span>
                    </div>
                  </a>
                </li>
                <li class="sidebar-item">
                  <a class="sidebar-link justify-content-between" href="make_appointment.php">
                    <div class="d-flex align-items-center gap-3">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Make Appointment</span>
                    </div>
                  </a>
                </li>
              </ul>
            </li>
             <li class="sidebar-item">
              <a class="sidebar-link justify-content-between has-arrow" href="javascript:void(0)" aria-expanded="false">
                <div class="d-flex align-items-center gap-3">
                  <i class="bi bi-person-badge"></i>
                  <span class="hide-menu">Patient</span>
                </div>
              </a>
              <ul aria-expanded="false" class="collapse first-level">
                <li class="sidebar-item">
                  <a class="sidebar-link justify-content-between" href="#">
                    <div class="d-flex align-items-center gap-3">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Patient Details</span>
                    </div>
                  </a>
                </li>
                <li class="sidebar-item">
                  <a class="sidebar-link justify-content-between" href="patientlist.php">
                    <div class="d-flex align-items-center gap-3">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">All Patient</span>
                    </div>
                  </a>
                </li>
                <li class="sidebar-item">
                  <a class="sidebar-link justify-content-between" href="#">
                    <div class="d-flex align-items-center gap-3">
                      <i class="ti ti-circle"></i>
                      <span class="hide-menu">Register</span>
                    </div>
                  </a>
                </li>
              </ul>
            </li>
            <li class="sidebar-item">
              <a class="sidebar-link" href="#" aria-expanded="false">
                <i class="bi bi-credit-card"></i>
                <span class="hide-menu">Payment</span>
              </a>
            </li>
          </ul>
        </nav>
      </div>
      <!-- End Sidebar scroll-->
    </aside>
    <!-- Sidebar End -->

    <!-- Main wrapper -->
    <div class="body-wrapper">
      <!-- Header Start -->
<header class="app-header">
  <nav class="navbar navbar-expand-lg navbar-light">
    
           <div class="navbar-brand ms-2">
      <span class="fw-bold fs-5">Make Appointment</span>
    </div>

    <!-- Sidebar + Notifikasi -->
    <ul class="navbar-nav ms-3">
      <li class="nav-item d-block d-xl-none">
        <a class="nav-link sidebartoggler" id="headerCollapse" href="javascript:void(0)">
          <i class="ti ti-menu-2"></i>
        </a>
      </li>

      <!-- Notifikasi dipindahkan ke kiri -->
      <li class="nav-item dropdown">
        <a class="nav-link" href="javascript:void(0)" id="drop1" data-bs-toggle="dropdown" aria-expanded="false">
          <i class="ti ti-bell"></i>
          <div class="notification bg-primary rounded-circle"></div>
        </a>
        <div class="dropdown-menu dropdown-menu-animate-up" aria-labelledby="drop1">
          <div class="message-body">
            <a href="javascript:void(0)" class="dropdown-item">Item 1</a>
            <a href="javascript:void(0)" class="dropdown-item">Item 2</a>
          </div>
        </div>
      </li>
    </ul>

    <!-- Profil -->
 <!-- Profil -->
<div class="navbar-collapse justify-content-end px-0" id="navbarNav">
  <ul class="navbar-nav flex-row ms-auto align-items-center justify-content-end pe-4">
    <li class="nav-item dropdown d-flex align-items-center">
      
      <!-- Nama user di samping foto -->
      <span class="me-2 fw-semibold"><?= htmlspecialchars($nama_user) ?></span>

      <a class="nav-link p-0" href="javascript:void(0)" id="drop2" data-bs-toggle="dropdown" aria-expanded="false">
        <img src="./assets/images/profile/user-1.jpg" alt="" width="35" height="35" class="rounded-circle">
      </a>

      <!-- Dropdown profile dengan card -->
      <div class="dropdown-menu dropdown-menu-end dropdown-menu-animate-up" aria-labelledby="drop2">
        <div class="card shadow-sm border-0" style="width: 250px;">
          <div class="card-body text-center">
            <img src="./assets/images/profile/user-1.jpg" alt="" width="60" height="60" class="rounded-circle mb-2">
            <h6 class="mb-0"><?= htmlspecialchars($nama_user) ?></h6>
          </div>
          <div class="card-footer">
            <a href="logout.php" class="btn btn-outline-primary w-100">Logout</a>
          </div>
        </div>
      </div>
    </li>
  </ul>

    </div>
  </nav>
</header>
<!-- Header End -->
      <!-- Content Start -->
      <div class="body-wrapper-inner">
        <div class="container-fluid">
          <!-- Row 1 -->
   <h2>Data Diri Pasien</h2>

    <?php if (!empty($error_msg)): ?>
      <div class="error"><?= htmlspecialchars($error_msg) ?></div>
    <?php endif; ?>

    <form method="post" action="">
      <!-- Nama -->
      <label>Nama Lengkap</label>
      <input type="text" name="nama" class="form-control" placeholder="Nama" required>

      <!-- Telepon -->
      <label>No Telepon / WA</label>
      <input type="number" name="no_hp" class="form-control" placeholder="No Telepon" required>

      <!-- Alamat -->
      <label>Alamat</label>
      <input type="text" name="alamat" class="form-control" placeholder="Alamat" required>

      <!-- Tanggal Lahir -->
      <label>Tanggal Lahir</label>
      <div class="row g-2">
        <div class="col-md-4">
          <input type="number" name="tanggal" class="form-control" placeholder="Tanggal" min="1" max="31" required>
        </div>
        <div class="col-md-4">
          <input type="number" name="bulan" class="form-control" placeholder="Bulan" min="1" max="12" required>
        </div>
        <div class="col-md-4">
          <input type="number" name="tahun" class="form-control" placeholder="Tahun" min="1900" max="<?php echo date('Y'); ?>" required>
        </div>
      </div>

         <!-- Gender -->
      <label>Gender</label>
      <div class="btn-group d-flex mb-2" role="group">
        <input type="radio" class="btn-check" name="gender" id="genderL" value="Laki-laki" autocomplete="off" required>
        <label class="btn btn-outline-danger flex-fill" for="genderL">Laki-laki</label>

       <input type="radio" class="btn-check" name="gender" id="genderP" value="Perempuan" autocomplete="off" required>
        <label class="btn btn-outline-danger flex-fill" for="genderP">Perempuan</label>
      </div>

      <br>
      <button type="submit" name="simpan" class="btn-submit">Simpan</button>
    </form>
    </div><!-- End body-wrapper -->
  </div><!-- End page-wrapper -->

  <script src="./assets/libs/jquery/dist/jquery.min.js"></script>
  <script src="./assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
  <script src="./assets/js/sidebarmenu.js"></script>
  <script src="./assets/js/app.min.js"></script>
  <script src="./assets/libs/apexcharts/dist/apexcharts.min.js"></script>
  <script src="./assets/libs/simplebar/dist/simplebar.js"></script>
  <script src="./assets/js/dashboard.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
</body>

</html>
