<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Không có quyền truy cập | Gen-CMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body {
            background-color: #f8f9fa;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .error-container {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            max-width: 600px;
            width: 90%;
            border-bottom: 5px solid #dc3545; /* Màu đỏ cảnh báo */
        }
        .error-code {
            font-size: 8rem;
            font-weight: 900;
            color: #dc3545;
            line-height: 1;
            margin-bottom: 20px;
            text-shadow: 4px 4px 0px rgba(220, 53, 69, 0.1);
        }
        .error-icon {
            font-size: 5rem;
            color: #ffc107; /* Màu vàng cảnh báo */
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #343a40;
            margin-bottom: 10px;
        }
        .error-message {
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 30px;
        }
        .btn-home {
            background-color: #0d6efd;
            border: none;
            padding: 10px 25px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-home:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
        }
        .btn-back {
            border-radius: 50px;
            padding: 10px 25px;
            font-weight: 600;
        }
    </style>
</head>
<body>

    <div class="error-container">
        <div class="mb-3">
            <i class="fas fa-user-lock error-icon"></i>
        </div>

        <div class="error-code">403</div>

        <div class="error-title">Xin lỗi, bạn không có quyền truy cập!</div>

        <p class="error-message">
            Trang này yêu cầu quyền hạn cao hơn hoặc thuộc về bộ phận khác.<br>
            Vui lòng liên hệ Admin nếu bạn nghĩ đây là một sự nhầm lẫn.
        </p>

        <div class="d-flex justify-content-center gap-3">
            <button onclick="history.back()" class="btn btn-outline-secondary btn-back">
                <i class="fas fa-arrow-left me-2"></i> Quay lại
            </button>
        </div>
    </div>

</body>
</html>