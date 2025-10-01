<?php include 'header.php'; ?>

<main class="main">

  <section id="hero" class="hero section light-background">
    <div class="container">
      <div class="row gy-4 justify-content-center justify-content-lg-between">
        <div class="col-lg-5 order-2 order-lg-1 d-flex flex-column justify-content-center">
          <h1 data-aos="fade-up">Tumbuh Kembang <br>Pratama</h1>
          <p data-aos="fade-up" data-aos-delay="100">Perawatan gigi terpercaya untuk senyum<br> sehat dan indah</p>
          
          <div class="d-flex" data-aos="fade-up" data-aos-delay="200">
            
            <?php if (!isset($_SESSION['user_telepon'])) : ?>
              <a href="#" class="btn-get-started" data-bs-toggle="modal" data-bs-target="#loginModal">Login</a>
            <?php endif; ?>

          </div>
        </div>
        <div class="col-lg-5 order-1 order-lg-2 hero-img" data-aos="zoom-out">
          <img src="assets/img/gigi.png" class="img-fluid animated" alt="">
        </div>
      </div>
    </div>
  </section><section id="testimonials" class="testimonials section white-background">
    <div class="container section-title" data-aos="fade-up">
      <h2>TESTIMONIALS</h2>
      <p>What Are They <span class="description-title">Saying About Us</span></p>
    </div><div class="container" data-aos="fade-up" data-aos-delay="100">
      <div class="swiper init-swiper">
        <script type="application/json" class="swiper-config">
          {
            "loop": true,
            "speed": 600,
            "autoplay": { "delay": 5000 },
            "slidesPerView": "auto",
            "pagination": { "el": ".swiper-pagination", "type": "bullets", "clickable": true }
          }
        </script>

        <div class="swiper-wrapper">

          <div class="swiper-slide">
            <div class="testimonial-item">
              <div class="row gy-4 justify-content-center">
                <div class="col-lg-6">
                  <div class="testimonial-content">
                    <div class="testimonial-author">
                      <div class="author-name">
                        <h3>Kania Dewi</h3>
                        <i class="bi bi-patch-check-fill verified-badge"></i>
                      </div>
                      <div class="posted-on">
                        <span>Posted on </span>
                        <span class="google-logo">
                          <span class="g-blue">G</span><span class="g-red">o</span><span class="g-yellow">o</span><span class="g-blue">g</span><span class="g-green">l</span><span class="g-red">e</span>
                        </span>
                      </div>
                      <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                      </div>
                    <p>
                      <i class="bi bi-quote quote-icon-left"></i>
                      <span>Tempatnya nyaman, anak gaakan bosen nunggu giliran di periksaa. Dokternya baik ramah 😊</span>
                      <i class="bi bi-quote quote-icon-right"></i>
                    </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div><div class="swiper-slide">
            <div class="testimonial-item">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-6">
                      <div class="testimonial-content">
                        <div class="testimonial-author">
                          <div class="author-name">
                            <h3>Handyan Rozadi</h3>
                            <i class="bi bi-patch-check-fill verified-badge"></i>
                          </div>
                          <div class="posted-on">
                            <span>Posted on </span>
                            <span class="google-logo">
                              <span class="g-blue">G</span><span class="g-red">o</span><span class="g-yellow">o</span><span class="g-blue">g</span><span class="g-green">l</span><span class="g-red">e</span>
                            </span>
                          </div>
                          <div class="stars">
                            <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                          </div>
                        <p>
                          <i class="bi bi-quote quote-icon-left"></i>
                          <span>Ruang tunggunya nyaman buat anak2. Dokternya juga ramah2 pada anak sehingga anak tidak rewel waktu diperiksa</span>
                          <i class="bi bi-quote quote-icon-right"></i>
                        </p>
                        </div>
                      </div>
                    </div>
                  </div>
            </div>
          </div><div class="swiper-slide">
              <div class="testimonial-item">
                <div class="row gy-4 justify-content-center">
                  <div class="col-lg-6">
                    <div class="testimonial-content">
                      <div class="testimonial-author">
                        <div class="author-name">
                          <h3>liestianto budicahyono</h3>
                          <i class="bi bi-patch-check-fill verified-badge"></i>
                        </div>
                        <div class="posted-on">
                          <span>Posted on </span>
                          <span class="google-logo">
                            <span class="g-blue">G</span><span class="g-red">o</span><span class="g-yellow">o</span><span class="g-blue">g</span><span class="g-green">l</span><span class="g-red">e</span>
                          </span>
                        </div>
                        <div class="stars">
                          <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                        </div>
                      <p>
                        <i class="bi bi-quote quote-icon-left"></i>
                        <span>Dokter ramah dan sabar, anak saya cocok dengan dokter teguh. Ruang tunggu nyaman, ada buku komik dan pajangan robot2an nya (itu yg buat betah nunggunya 😁😁)</span>
                        <i class="bi bi-quote quote-icon-right"></i>
                      </p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div></div>
        <div class="swiper-pagination"></div>
      </div>
    </div>
  </section><section id="karakter-trivia" class="karakter-trivia section">
    <div class="container section-title" data-aos="fade-up">
      <h2>Trivia</h2>
      <p><span>Kenali</span> <span class="description-title">Karakter Kami</span></p>
    </div>
    <div class="container" data-aos="fade-up" data-aos-delay="100">
      <div class="swiper karakter-utama-slider">
        <div class="swiper-wrapper">
          <div class="swiper-slide">
            <img src="assets/img/Manusia.png" class="karakter-img" alt="Manusia AA">
            <div class="karakter-info">
              <h3>MANUSIA AA</h3>
              <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac efficitur lectus. Vivamus eget pulvinar ligula.</p>
            </div>
          </div>
          <div class="swiper-slide">
            <img src="assets/img/ungu.png" class="karakter-img" alt="Monster Ungu">
            <div class="karakter-info">
              <h3>MONSTER UNGU</h3>
              <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
            </div>
          </div>
          <div class="swiper-slide">
            <img src="assets/img/hijau.png" class="karakter-img" alt="Monster Hijau">
            <div class="karakter-info">
              <h3>MONSTER HIJAU</h3>
              <p>Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
            </div>
          </div>
        </div>
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
      </div>
    </div>
  </section><section id="contact" class="contact section">
    <div class="container section-title" data-aos="fade-up">
      <h2>Contact</h2>
      <p><span>Need Help?</span> <span class="description-title">Contact Us</span></p>
    </div><div class="container" data-aos="fade-up" data-aos-delay="100">
      <div class="mb-5">
        <iframe style="width: 100%; height: 400px;" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3960.1313266983675!2d110.4312195103638!3d-6.993810092978081!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e708caefa5913bf%3A0xf19852b82670be43!2sTumbuh%20Kembang%20Pratama%20Dental%20Care!5e0!3m2!1sen!2sus!4v1759127408936!5m2!1sen!2sus" frameborder="0" allowfullscreen=""></iframe>
      </div><div class="row gy-4">
        <div class="col-md-6">
          <div class="info-item d-flex align-items-center" data-aos="fade-up" data-aos-delay="200">
            <i class="icon bi bi-geo-alt flex-shrink-0"></i>
            <div>
              <h3>Alamat</h3>
              <p>Jalan Dokter Cipto No.181b, Karangturi, Kec. Semarang Tim., Kota Semarang</p>
            </div>
          </div>
        </div><div class="col-md-6">
          <div class="info-item d-flex align-items-center" data-aos="fade-up" data-aos-delay="500">
            <i class="icon bi bi-clock flex-shrink-0"></i>
            <div>
              <h3>Jadwal Buka<br></h3>
              <p><strong>Pagi :</strong> 09:00 - 12:00; <strong>Sore :</strong> 16:00 - 20:00</p>
            </div>
          </div>
        </div></div>
    </div>
  </section></main><?php include 'footer.php'; ?>